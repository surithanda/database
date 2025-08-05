INSERT INTO countries (
    country_name, official_name, country_code_2, country_code_3, 
    country_number, country_calling_code, region, latitude, longitude, 
    flag_emoji, flag_image_url
) VALUES
-- North America
('United States', 'United States of America', 'US', 'USA', '840', '+1', 'Americas', 37.09024, -95.71289, '🇺🇸', 'https://flagcdn.com/us.svg'),
('Canada', 'Canada', 'CA', 'CAN', '124', '+1', 'Americas', 56.13037, -106.34677, '🇨🇦', 'https://flagcdn.com/ca.svg'),
('Mexico', 'United Mexican States', 'MX', 'MEX', '484', '+52', 'Americas', 23.63450, -102.55278, '🇲🇽', 'https://flagcdn.com/mx.svg'),

-- South America
('Brazil', 'Federative Republic of Brazil', 'BR', 'BRA', '076', '+55', 'Americas', -14.23500, -51.92528, '🇧🇷', 'https://flagcdn.com/br.svg'),
('Argentina', 'Argentine Republic', 'AR', 'ARG', '032', '+54', 'Americas', -38.41610, -63.61667, '🇦🇷', 'https://flagcdn.com/ar.svg'),
('Colombia', 'Republic of Colombia', 'CO', 'COL', '170', '+57', 'Americas', 4.57087, -74.29733, '🇨🇴', 'https://flagcdn.com/co.svg'),

-- Europe
('Germany', 'Federal Republic of Germany', 'DE', 'DEU', '276', '+49', 'Europe', 51.16569, 10.45153, '🇩🇪', 'https://flagcdn.com/de.svg'),
('France', 'French Republic', 'FR', 'FRA', '250', '+33', 'Europe', 46.22764, 2.21375, '🇫🇷', 'https://flagcdn.com/fr.svg'),
('United Kingdom', 'United Kingdom of Great Britain and Northern Ireland', 'GB', 'GBR', '826', '+44', 'Europe', 55.37805, -3.43597, '🇬🇧', 'https://flagcdn.com/gb.svg'),
('Italy', 'Italian Republic', 'IT', 'ITA', '380', '+39', 'Europe', 41.87194, 12.56738, '🇮🇹', 'https://flagcdn.com/it.svg'),
('Spain', 'Kingdom of Spain', 'ES', 'ESP', '724', '+34', 'Europe', 40.46367, -3.74922, '🇪🇸', 'https://flagcdn.com/es.svg'),
('Russia', 'Russian Federation', 'RU', 'RUS', '643', '+7', 'Europe', 61.52401, 105.31876, '🇷🇺', 'https://flagcdn.com/ru.svg'),

-- Asia
('China', 'People''s Republic of China', 'CN', 'CHN', '156', '+86', 'Asia', 35.86166, 104.19540, '🇨🇳', 'https://flagcdn.com/cn.svg'),
('India', 'Republic of India', 'IN', 'IND', '356', '+91', 'Asia', 20.59368, 78.96288, '🇮🇳', 'https://flagcdn.com/in.svg'),
('Japan', 'Japan', 'JP', 'JPN', '392', '+81', 'Asia', 36.20482, 138.25292, '🇯🇵', 'https://flagcdn.com/jp.svg'),
('South Korea', 'Republic of Korea', 'KR', 'KOR', '410', '+82', 'Asia', 35.90776, 127.76692, '🇰🇷', 'https://flagcdn.com/kr.svg'),
('Indonesia', 'Republic of Indonesia', 'ID', 'IDN', '360', '+62', 'Asia', -0.78928, 113.92133, '🇮🇩', 'https://flagcdn.com/id.svg'),

-- Africa
('Nigeria', 'Federal Republic of Nigeria', 'NG', 'NGA', '566', '+234', 'Africa', 9.081999, 8.675277, '🇳🇬', 'https://flagcdn.com/ng.svg'),
('South Africa', 'Republic of South Africa', 'ZA', 'ZAF', '710', '+27', 'Africa', -30.55948, 22.93751, '🇿🇦', 'https://flagcdn.com/za.svg'),
('Egypt', 'Arab Republic of Egypt', 'EG', 'EGY', '818', '+20', 'Africa', 26.82055, 30.80250, '🇪🇬', 'https://flagcdn.com/eg.svg'),

-- Oceania
('Australia', 'Commonwealth of Australia', 'AU', 'AUS', '036', '+61', 'Oceania', -25.27440, 133.77514, '🇦🇺', 'https://flagcdn.com/au.svg'),
('New Zealand', 'New Zealand', 'NZ', 'NZL', '554', '+64', 'Oceania', -40.90056, 174.88597, '🇳🇿', 'https://flagcdn.com/nz.svg'),

-- Middle East
('Saudi Arabia', 'Kingdom of Saudi Arabia', 'SA', 'SAU', '682', '+966', 'Asia', 23.88594, 45.07916, '🇸🇦', 'https://flagcdn.com/sa.svg'),
('Turkey', 'Republic of Turkey', 'TR', 'TUR', '792', '+90', 'Asia', 38.96374, 35.24332, '🇹🇷', 'https://flagcdn.com/tr.svg'),
('Israel', 'State of Israel', 'IL', 'ISR', '376', '+972', 'Asia', 31.04605, 34.85161, '🇮🇱', 'https://flagcdn.com/il.svg');