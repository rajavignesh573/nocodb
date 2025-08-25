-- Product Matching Database Schema
-- This script creates all necessary tables for the product matching system

-- Create nc_product_match_sources table
CREATE TABLE IF NOT EXISTS nc_product_match_sources (
  id VARCHAR(20) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) NOT NULL UNIQUE,
  base_config TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at VARCHAR(50) NOT NULL,
  created_by VARCHAR(255),
  updated_at VARCHAR(50),
  updated_by VARCHAR(255)
);

-- Create nc_internal_products table (for internal product catalog)
CREATE TABLE IF NOT EXISTS nc_internal_products (
  id VARCHAR(20) PRIMARY KEY,
  tenant_id VARCHAR(255),
  title VARCHAR(500) NOT NULL,
  brand VARCHAR(255),
  category_id VARCHAR(100),
  price DECIMAL(10,2),
  gtin VARCHAR(50),
  sku VARCHAR(100),
  description TEXT,
  image_url VARCHAR(500),
  is_active BOOLEAN DEFAULT true,
  created_at VARCHAR(50) NOT NULL,
  created_by VARCHAR(255),
  updated_at VARCHAR(50),
  updated_by VARCHAR(255)
);

-- Create nc_external_products table (for scraped external data)
CREATE TABLE IF NOT EXISTS nc_external_products (
  id VARCHAR(20) PRIMARY KEY,
  external_product_key VARCHAR(255) NOT NULL,
  source_id VARCHAR(20) NOT NULL,
  title VARCHAR(500) NOT NULL,
  brand VARCHAR(255),
  category_id VARCHAR(100),
  price DECIMAL(10,2),
  gtin VARCHAR(50),
  sku VARCHAR(100),
  description TEXT,
  image_url VARCHAR(500),
  product_url VARCHAR(500),
  availability BOOLEAN DEFAULT true,
  last_scraped_at VARCHAR(50),
  created_at VARCHAR(50) NOT NULL,
  updated_at VARCHAR(50),
  FOREIGN KEY (source_id) REFERENCES nc_product_match_sources(id)
);

-- Create nc_product_match_brand_synonyms table
CREATE TABLE IF NOT EXISTS nc_product_match_brand_synonyms (
  id VARCHAR(20) PRIMARY KEY,
  tenant_id VARCHAR(255),
  brand_canonical VARCHAR(255) NOT NULL,
  brand_variant VARCHAR(255) NOT NULL,
  confidence DECIMAL(3,2),
  created_at VARCHAR(50) NOT NULL,
  created_by VARCHAR(255),
  updated_at VARCHAR(50),
  updated_by VARCHAR(255)
);

-- Create nc_product_match_rules table
CREATE TABLE IF NOT EXISTS nc_product_match_rules (
  id VARCHAR(20) PRIMARY KEY,
  tenant_id VARCHAR(255),
  name VARCHAR(255) NOT NULL,
  weights TEXT NOT NULL,
  price_band_pct DECIMAL(5,2) DEFAULT 15,
  algorithm VARCHAR(50) DEFAULT 'jarowinkler',
  min_score DECIMAL(3,2) DEFAULT 0.65,
  is_default BOOLEAN DEFAULT false,
  created_at VARCHAR(50) NOT NULL,
  created_by VARCHAR(255),
  updated_at VARCHAR(50),
  updated_by VARCHAR(255)
);

-- Create nc_product_match_sessions table
CREATE TABLE IF NOT EXISTS nc_product_match_sessions (
  id VARCHAR(20) PRIMARY KEY,
  tenant_id VARCHAR(255),
  created_by VARCHAR(255),
  note TEXT,
  created_at VARCHAR(50) NOT NULL,
  updated_at VARCHAR(50)
);

-- Create nc_product_matches table
CREATE TABLE IF NOT EXISTS nc_product_matches (
  id VARCHAR(20) PRIMARY KEY,
  tenant_id VARCHAR(255),
  local_product_id VARCHAR(20) NOT NULL,
  external_product_key VARCHAR(255) NOT NULL,
  source_id VARCHAR(20) NOT NULL,
  score DECIMAL(3,2),
  price_delta_pct DECIMAL(8,2),
  rule_id VARCHAR(20),
  session_id VARCHAR(20),
  status VARCHAR(20) DEFAULT 'matched' CHECK (status IN ('matched', 'not_matched', 'superseded')),
  reviewed_by VARCHAR(255),
  reviewed_at VARCHAR(50),
  notes TEXT,
  version INTEGER DEFAULT 1,
  created_at VARCHAR(50) NOT NULL,
  created_by VARCHAR(255),
  updated_at VARCHAR(50),
  updated_by VARCHAR(255),
  FOREIGN KEY (source_id) REFERENCES nc_product_match_sources(id),
  FOREIGN KEY (rule_id) REFERENCES nc_product_match_rules(id),
  FOREIGN KEY (session_id) REFERENCES nc_product_match_sessions(id),
  FOREIGN KEY (local_product_id) REFERENCES nc_internal_products(id)
);

-- Create nc_media_assets table
CREATE TABLE IF NOT EXISTS nc_media_assets (
  id VARCHAR(20) PRIMARY KEY,
  tenant_id VARCHAR(255),
  url VARCHAR(1000) NOT NULL,
  type VARCHAR(50) DEFAULT 'image',
  alt_text VARCHAR(500),
  checksum VARCHAR(100),
  width INTEGER,
  height INTEGER,
  meta TEXT,
  created_at VARCHAR(50) NOT NULL,
  created_by VARCHAR(255),
  updated_at VARCHAR(50),
  updated_by VARCHAR(255)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_internal_products_tenant ON nc_internal_products(tenant_id);
CREATE INDEX IF NOT EXISTS idx_internal_products_brand ON nc_internal_products(brand);
CREATE INDEX IF NOT EXISTS idx_internal_products_category ON nc_internal_products(category_id);
CREATE INDEX IF NOT EXISTS idx_internal_products_active ON nc_internal_products(is_active);

CREATE INDEX IF NOT EXISTS idx_external_products_source ON nc_external_products(source_id);
CREATE INDEX IF NOT EXISTS idx_external_products_brand ON nc_external_products(brand);
CREATE INDEX IF NOT EXISTS idx_external_products_category ON nc_external_products(category_id);
CREATE INDEX IF NOT EXISTS idx_external_products_gtin ON nc_external_products(gtin);

CREATE INDEX IF NOT EXISTS idx_product_matches_local_product ON nc_product_matches(local_product_id);
CREATE INDEX IF NOT EXISTS idx_product_matches_external_key ON nc_product_matches(external_product_key);
CREATE INDEX IF NOT EXISTS idx_product_matches_source ON nc_product_matches(source_id);
CREATE INDEX IF NOT EXISTS idx_product_matches_status ON nc_product_matches(status);
CREATE INDEX IF NOT EXISTS idx_product_matches_tenant ON nc_product_matches(tenant_id);

CREATE INDEX IF NOT EXISTS idx_brand_synonyms_canonical ON nc_product_match_brand_synonyms(brand_canonical);
CREATE INDEX IF NOT EXISTS idx_brand_synonyms_variant ON nc_product_match_brand_synonyms(brand_variant);

-- Insert default matching rule
INSERT INTO nc_product_match_rules (
  id, 
  tenant_id, 
  name, 
  weights, 
  price_band_pct, 
  algorithm, 
  min_score, 
  is_default, 
  created_at
) VALUES (
  'rule-default-001',
  NULL,
  'Default Matching Rule',
  '{"name": 0.4, "brand": 0.3, "gtin": 0.2, "price": 0.1}',
  15.00,
  'jarowinkler',
  0.65,
  true,
  NOW()::text
) ON CONFLICT (id) DO NOTHING;

-- Insert sample data sources
INSERT INTO nc_product_match_sources (
  id, 
  name, 
  code, 
  base_config, 
  is_active, 
  created_at
) VALUES 
  ('src-amazon-001', 'Amazon', 'AMZ', '{"base_url": "https://amazon.com", "api_key": ""}', true, NOW()::text),
  ('src-target-001', 'Target', 'TGT', '{"base_url": "https://target.com", "api_key": ""}', true, NOW()::text),
  ('src-walmart-001', 'Walmart', 'WMT', '{"base_url": "https://walmart.com", "api_key": ""}', true, NOW()::text),
  ('src-buybuybaby-001', 'BuyBuy Baby', 'BBB', '{"base_url": "https://buybuybaby.com", "api_key": ""}', true, NOW()::text),
  ('src-babiesrus-001', 'Babies R Us', 'BRU', '{"base_url": "https://babiesrus.com", "api_key": ""}', true, NOW()::text)
ON CONFLICT (id) DO NOTHING;

COMMIT;
