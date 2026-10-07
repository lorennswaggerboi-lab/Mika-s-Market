-- ============================================================
-- PULSO — Script de Configuración de Base de Datos (Supabase)
-- ============================================================
-- Ejecutar este script en el SQL Editor de Supabase
-- Dashboard → SQL Editor → New Query → Pegar y ejecutar
-- ============================================================


-- ============================================================
-- 1. TABLA DE PRODUCTOS
-- ============================================================
-- Almacena toda la información de cada publicación/producto

CREATE TABLE IF NOT EXISTS public.products (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  title       TEXT NOT NULL,
  price       NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
  description TEXT,
  phone       TEXT NOT NULL,                          -- Número de WhatsApp con código de país
  whatsapp_message TEXT DEFAULT '',                   -- Mensaje predeterminado de WhatsApp
  images      TEXT[] NOT NULL DEFAULT '{}',           -- Array de URLs de imágenes
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE  -- Usuario que creó el producto
);

-- Índice para búsquedas por usuario
CREATE INDEX IF NOT EXISTS idx_products_user_id ON public.products(user_id);

-- Índice para ordenamiento por fecha
CREATE INDEX IF NOT EXISTS idx_products_created_at ON public.products(created_at DESC);


-- ============================================================
-- 2. ROW LEVEL SECURITY (RLS) — Políticas de seguridad
-- ============================================================
-- Habilitar RLS en la tabla de productos
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Política: LECTURA — Cualquier persona puede ver los productos (público)
CREATE POLICY "Productos visibles para todos"
  ON public.products
  FOR SELECT
  USING (true);

-- Política: INSERCIÓN — Solo usuarios autenticados pueden crear productos
-- (La restricción por email del admin se maneja en el frontend + función RPC opcional)
CREATE POLICY "Usuarios autenticados pueden insertar productos"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Política: ACTUALIZACIÓN — Solo el dueño del producto puede editarlo
CREATE POLICY "Solo el dueño puede actualizar sus productos"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Política: ELIMINACIÓN — Solo el dueño del producto puede eliminarlo
CREATE POLICY "Solo el dueño puede eliminar sus productos"
  ON public.products
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);


-- ============================================================
-- 3. STORAGE — Bucket para imágenes de productos
-- ============================================================
-- Crear bucket público para almacenar las fotos de los productos

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'product-images',
  'product-images',
  true,                                               -- Bucket público (las URLs son accesibles)
  5242880,                                             -- Límite: 5 MB por archivo
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']  -- Solo imágenes
)
ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- 4. POLÍTICAS DE STORAGE — Control de acceso a archivos
-- ============================================================

-- Política: Cualquier persona puede ver/descargar imágenes (público)
CREATE POLICY "Imágenes de productos accesibles públicamente"
  ON storage.objects
  FOR SELECT
  USING (bucket_id = 'product-images');

-- Política: Solo usuarios autenticados pueden subir imágenes
CREATE POLICY "Usuarios autenticados pueden subir imágenes"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'product-images');

-- Política: Solo usuarios autenticados pueden actualizar sus imágenes
CREATE POLICY "Usuarios autenticados pueden actualizar imágenes"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (bucket_id = 'product-images');

-- Política: Solo usuarios autenticados pueden eliminar imágenes
CREATE POLICY "Usuarios autenticados pueden eliminar imágenes"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (bucket_id = 'product-images');


-- ============================================================
-- 5. (OPCIONAL) FUNCIÓN RPC PARA RESTRICCIÓN POR EMAIL
-- ============================================================
-- Función auxiliar para verificar si el usuario actual es el admin
-- Puede usarse en políticas más estrictas si se desea

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND email = 'micaelavanesarosica@gmail.com'
  );
$$;

-- Si deseas una restricción más estricta por email en las políticas,
-- puedes reemplazar las políticas de INSERT/UPDATE/DELETE con:
--
-- CREATE POLICY "Solo admin puede insertar"
--   ON public.products FOR INSERT TO authenticated
--   WITH CHECK (public.is_admin());
--
-- CREATE POLICY "Solo admin puede actualizar"
--   ON public.products FOR UPDATE TO authenticated
--   USING (public.is_admin()) WITH CHECK (public.is_admin());
--
-- CREATE POLICY "Solo admin puede eliminar"
--   ON public.products FOR DELETE TO authenticated
--   USING (public.is_admin());


-- ============================================================
-- ✅ ¡Configuración completada!
-- ============================================================
-- Ahora puedes:
-- 1. Copiar tu SUPABASE_URL y SUPABASE_ANON_KEY desde Settings → API
-- 2. Pegarlas en index.html
-- 3. Registrar la cuenta admin: micaelavanesarosica@gmail.com
-- 4. ¡Empezar a publicar productos!
