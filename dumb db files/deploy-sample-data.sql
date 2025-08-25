-- Sample Data for Product Matching System
-- This script populates the database with sample products and matches

-- Insert sample internal products
INSERT INTO nc_internal_products (
  id, 
  tenant_id, 
  title, 
  brand, 
  category_id, 
  price, 
  gtin, 
  sku, 
  description, 
  image_url, 
  is_active, 
  created_at
) VALUES 
  ('int-001', NULL, 'UPPAbaby VISTA V2 Stroller', 'UPPAbaby', 'strollers', 969.99, '1234567890123', 'UPP-STR-0001', 'Premium stroller with multiple configurations', 'https://example.com/uppababy-vista.jpg', true, NOW()::text),
  ('int-002', NULL, 'Bugaboo Fox 3 Stroller', 'Bugaboo', 'strollers', 1299.00, '1234567890124', 'BUG-STR-0001', 'Luxury stroller with all-terrain capability', 'https://example.com/bugaboo-fox.jpg', true, NOW()::text),
  ('int-003', NULL, 'Nuna MIXX Next Stroller', 'Nuna', 'strollers', 649.95, '1234567890125', 'NUN-STR-0001', 'Compact and lightweight stroller', 'https://example.com/nuna-mixx.jpg', true, NOW()::text),
  ('int-004', NULL, 'Cybex Gazelle S Stroller', 'Cybex', 'strollers', 849.95, '1234567890126', 'CYB-STR-0001', 'Versatile stroller for growing families', 'https://example.com/cybex-gazelle.jpg', true, NOW()::text),
  ('int-005', NULL, 'Thule Spring Stroller', 'Thule', 'strollers', 399.95, '1234567890127', 'THU-STR-0001', 'Active lifestyle stroller', 'https://example.com/thule-spring.jpg', true, NOW()::text),
  ('int-006', NULL, 'Graco Modes Pramette Stroller', 'Graco', 'strollers', 299.99, '8717447138327', 'GRA-STR-0001', 'Affordable 3-in-1 travel system', 'https://example.com/graco-modes.jpg', true, NOW()::text),
  ('int-007', NULL, 'Chicco Bravo Trio Travel System', 'Chicco', 'strollers', 399.99, '4058511661445', 'CHI-STR-0001', 'Complete travel system with car seat', 'https://example.com/chicco-bravo.jpg', true, NOW()::text),
  ('int-008', NULL, 'Evenflo Pivot Xpand Modular Travel System', 'Evenflo', 'strollers', 369.99, '817609018467', 'EVE-STR-0001', 'Modular system for multiple children', 'https://example.com/evenflo-pivot.jpg', true, NOW()::text),
  ('int-009', NULL, 'Babyzen YOYO2 Stroller', 'Babyzen', 'strollers', 499.99, '1234567890128', 'BAB-STR-0001', 'Ultra-compact travel stroller', 'https://example.com/babyzen-yoyo.jpg', true, NOW()::text),
  ('int-010', NULL, 'Britax B-Free Stroller', 'Britax', 'strollers', 379.99, '1234567890129', 'BRI-STR-0001', 'Lightweight and maneuverable stroller', 'https://example.com/britax-bfree.jpg', true, NOW()::text)
ON CONFLICT (id) DO NOTHING;

-- Insert sample external products
INSERT INTO nc_external_products (
  id, 
  external_product_key, 
  source_id, 
  title, 
  brand, 
  category_id, 
  price, 
  gtin, 
  sku, 
  description, 
  image_url, 
  product_url, 
  availability, 
  created_at
) VALUES 
  -- Amazon products
  ('ext-001', 'AMZ-UPPAbaby-VISTA-V2', 'src-amazon-001', 'UPPAbaby VISTA V2 Stroller - Black', 'UPPAbaby', 'strollers', 949.99, '1234567890123', 'AMZ-UPP-001', 'Premium stroller with multiple configurations', 'https://amazon.com/uppababy-vista.jpg', 'https://amazon.com/dp/B08XXXXX', true, NOW()::text),
  ('ext-002', 'AMZ-Bugaboo-Fox-3', 'src-amazon-001', 'Bugaboo Fox 3 Stroller - Charcoal', 'Bugaboo', 'strollers', 1279.00, '1234567890124', 'AMZ-BUG-001', 'Luxury stroller with all-terrain capability', 'https://amazon.com/bugaboo-fox.jpg', 'https://amazon.com/dp/B08YYYYY', true, NOW()::text),
  ('ext-003', 'AMZ-Nuna-MIXX-Next', 'src-amazon-001', 'Nuna MIXX Next Stroller - Graphite', 'Nuna', 'strollers', 629.95, '1234567890125', 'AMZ-NUN-001', 'Compact and lightweight stroller', 'https://amazon.com/nuna-mixx.jpg', 'https://amazon.com/dp/B08ZZZZZ', true, NOW()::text),
  
  -- Target products
  ('ext-004', 'TGT-UPPAbaby-VISTA-V2', 'src-target-001', 'UPPAbaby VISTA V2 Stroller', 'UPPAbaby', 'strollers', 989.99, '1234567890123', 'TGT-UPP-001', 'Premium stroller with multiple configurations', 'https://target.com/uppababy-vista.jpg', 'https://target.com/p/uppababy-vista', true, NOW()::text),
  ('ext-005', 'TGT-Graco-Modes', 'src-target-001', 'Graco Modes Pramette Stroller', 'Graco', 'strollers', 279.99, '8717447138327', 'TGT-GRA-001', 'Affordable 3-in-1 travel system', 'https://target.com/graco-modes.jpg', 'https://target.com/p/graco-modes', true, NOW()::text),
  ('ext-006', 'TGT-Chicco-Bravo', 'src-target-001', 'Chicco Bravo Trio Travel System', 'Chicco', 'strollers', 389.99, '4058511661445', 'TGT-CHI-001', 'Complete travel system with car seat', 'https://target.com/chicco-bravo.jpg', 'https://target.com/p/chicco-bravo', true, NOW()::text),
  
  -- Walmart products
  ('ext-007', 'WMT-Graco-Modes', 'src-walmart-001', 'Graco Modes Pramette Stroller', 'Graco', 'strollers', 259.99, '8717447138327', 'WMT-GRA-001', 'Affordable 3-in-1 travel system', 'https://walmart.com/graco-modes.jpg', 'https://walmart.com/ip/graco-modes', true, NOW()::text),
  ('ext-008', 'WMT-Evenflo-Pivot', 'src-walmart-001', 'Evenflo Pivot Xpand Modular Travel System', 'Evenflo', 'strollers', 349.99, '817609018467', 'WMT-EVE-001', 'Modular system for multiple children', 'https://walmart.com/evenflo-pivot.jpg', 'https://walmart.com/ip/evenflo-pivot', true, NOW()::text),
  ('ext-009', 'WMT-Britax-BFree', 'src-walmart-001', 'Britax B-Free Stroller', 'Britax', 'strollers', 359.99, '1234567890129', 'WMT-BRI-001', 'Lightweight and maneuverable stroller', 'https://walmart.com/britax-bfree.jpg', 'https://walmart.com/ip/britax-bfree', true, NOW()::text),
  
  -- BuyBuy Baby products
  ('ext-010', 'BBB-UPPAbaby-VISTA-V2', 'src-buybuybaby-001', 'UPPAbaby VISTA V2 Stroller', 'UPPAbaby', 'strollers', 999.99, '1234567890123', 'BBB-UPP-001', 'Premium stroller with multiple configurations', 'https://buybuybaby.com/uppababy-vista.jpg', 'https://buybuybaby.com/shop/uppababy-vista', true, NOW()::text),
  ('ext-011', 'BBB-Bugaboo-Fox-3', 'src-buybuybaby-001', 'Bugaboo Fox 3 Stroller', 'Bugaboo', 'strollers', 1319.00, '1234567890124', 'BBB-BUG-001', 'Luxury stroller with all-terrain capability', 'https://buybuybaby.com/bugaboo-fox.jpg', 'https://buybuybaby.com/shop/bugaboo-fox', true, NOW()::text),
  ('ext-012', 'BBB-Nuna-MIXX-Next', 'src-buybuybaby-001', 'Nuna MIXX Next Stroller', 'Nuna', 'strollers', 669.95, '1234567890125', 'BBB-NUN-001', 'Compact and lightweight stroller', 'https://buybuybaby.com/nuna-mixx.jpg', 'https://buybuybaby.com/shop/nuna-mixx', true, NOW()::text),
  
  -- Babies R Us products
  ('ext-013', 'BRU-Graco-Modes', 'src-babiesrus-001', 'Graco Modes Pramette Stroller', 'Graco', 'strollers', 289.99, '8717447138327', 'BRU-GRA-001', 'Affordable 3-in-1 travel system', 'https://babiesrus.com/graco-modes.jpg', 'https://babiesrus.com/shop/graco-modes', true, NOW()::text),
  ('ext-014', 'BRU-Chicco-Bravo', 'src-babiesrus-001', 'Chicco Bravo Trio Travel System', 'Chicco', 'strollers', 409.99, '4058511661445', 'BRU-CHI-001', 'Complete travel system with car seat', 'https://babiesrus.com/chicco-bravo.jpg', 'https://babiesrus.com/shop/chicco-bravo', true, NOW()::text),
  ('ext-015', 'BRU-Evenflo-Pivot', 'src-babiesrus-001', 'Evenflo Pivot Xpand Modular Travel System', 'Evenflo', 'strollers', 379.99, '817609018467', 'BRU-EVE-001', 'Modular system for multiple children', 'https://babiesrus.com/evenflo-pivot.jpg', 'https://babiesrus.com/shop/evenflo-pivot', true, NOW()::text)
ON CONFLICT (id) DO NOTHING;

-- Insert sample brand synonyms
INSERT INTO nc_product_match_brand_synonyms (
  id, 
  tenant_id, 
  brand_canonical, 
  brand_variant, 
  confidence, 
  created_at
) VALUES 
  ('syn-001', NULL, 'UPPAbaby', 'UPPAbaby', 1.00, NOW()::text),
  ('syn-002', NULL, 'UPPAbaby', 'UPPA Baby', 0.95, NOW()::text),
  ('syn-003', NULL, 'UPPAbaby', 'UPPA-Baby', 0.95, NOW()::text),
  ('syn-004', NULL, 'Bugaboo', 'Bugaboo', 1.00, NOW()::text),
  ('syn-005', NULL, 'Bugaboo', 'Bug-A-Boo', 0.90, NOW()::text),
  ('syn-006', NULL, 'Nuna', 'Nuna', 1.00, NOW()::text),
  ('syn-007', NULL, 'Cybex', 'Cybex', 1.00, NOW()::text),
  ('syn-008', NULL, 'Thule', 'Thule', 1.00, NOW()::text),
  ('syn-009', NULL, 'Graco', 'Graco', 1.00, NOW()::text),
  ('syn-010', NULL, 'Chicco', 'Chicco', 1.00, NOW()::text),
  ('syn-011', NULL, 'Evenflo', 'Evenflo', 1.00, NOW()::text),
  ('syn-012', NULL, 'Babyzen', 'Babyzen', 1.00, NOW()::text),
  ('syn-013', NULL, 'Britax', 'Britax', 1.00, NOW()::text)
ON CONFLICT (id) DO NOTHING;

-- Insert sample product matches
INSERT INTO nc_product_matches (
  id, 
  tenant_id, 
  local_product_id, 
  external_product_key, 
  source_id, 
  score, 
  price_delta_pct, 
  rule_id, 
  status, 
  created_at
) VALUES 
  ('match-001', NULL, 'int-001', 'AMZ-UPPAbaby-VISTA-V2', 'src-amazon-001', 0.95, -2.06, 'rule-default-001', 'matched', NOW()::text),
  ('match-002', NULL, 'int-001', 'TGT-UPPAbaby-VISTA-V2', 'src-target-001', 0.95, 2.06, 'rule-default-001', 'matched', NOW()::text),
  ('match-003', NULL, 'int-001', 'BBB-UPPAbaby-VISTA-V2', 'src-buybuybaby-001', 0.95, 3.10, 'rule-default-001', 'matched', NOW()::text),
  ('match-004', NULL, 'int-002', 'AMZ-Bugaboo-Fox-3', 'src-amazon-001', 0.92, -1.54, 'rule-default-001', 'matched', NOW()::text),
  ('match-005', NULL, 'int-002', 'BBB-Bugaboo-Fox-3', 'src-buybuybaby-001', 0.92, 1.54, 'rule-default-001', 'matched', NOW()::text),
  ('match-006', NULL, 'int-003', 'AMZ-Nuna-MIXX-Next', 'src-amazon-001', 0.88, -3.08, 'rule-default-001', 'matched', NOW()::text),
  ('match-007', NULL, 'int-003', 'BBB-Nuna-MIXX-Next', 'src-buybuybaby-001', 0.88, 3.08, 'rule-default-001', 'matched', NOW()::text),
  ('match-008', NULL, 'int-006', 'TGT-Graco-Modes', 'src-target-001', 0.85, -6.67, 'rule-default-001', 'matched', NOW()::text),
  ('match-009', NULL, 'int-006', 'WMT-Graco-Modes', 'src-walmart-001', 0.85, -13.33, 'rule-default-001', 'matched', NOW()::text),
  ('match-010', NULL, 'int-006', 'BRU-Graco-Modes', 'src-babiesrus-001', 0.85, -3.33, 'rule-default-001', 'matched', NOW()::text),
  ('match-011', NULL, 'int-007', 'TGT-Chicco-Bravo', 'src-target-001', 0.82, -2.50, 'rule-default-001', 'matched', NOW()::text),
  ('match-012', NULL, 'int-007', 'BRU-Chicco-Bravo', 'src-babiesrus-001', 0.82, 2.50, 'rule-default-001', 'matched', NOW()::text),
  ('match-013', NULL, 'int-008', 'WMT-Evenflo-Pivot', 'src-walmart-001', 0.78, -5.41, 'rule-default-001', 'matched', NOW()::text),
  ('match-014', NULL, 'int-008', 'BRU-Evenflo-Pivot', 'src-babiesrus-001', 0.78, 2.70, 'rule-default-001', 'matched', NOW()::text),
  ('match-015', NULL, 'int-010', 'WMT-Britax-BFree', 'src-walmart-001', 0.75, -5.26, 'rule-default-001', 'matched', NOW()::text)
ON CONFLICT (id) DO NOTHING;

COMMIT;
