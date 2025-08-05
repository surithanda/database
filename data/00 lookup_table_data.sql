truncate table lookup_table;

INSERT INTO `lookup_table` 
(category, name, description, isactive, created_at, updated_at)
VALUES 
-- address_type Options
('address_type','Present Address','Also known as current address, this is where the individual currently resides. It might differ from the permanent address, especially if the person has moved recently',1,NOW(),NOW()),
('address_type','Permanent Address','This is the address where the individual permanently resides or considers their primary place of residence. It usually doesn\'t change frequently.',1,NOW(),NOW()),
('address_type','Temporary Address','Sometimes individuals may have a temporary address, such as when they are staying at a different location for a short period of time. This could be relevant for students living in hostels or individuals temporarily relocating for work.',1,NOW(),NOW()),
('address_type','Work Address',' If applicable, the address of the individual\'s \nworkplace can be included. This is especially useful if the biodata is being used for employment purposes',1,NOW(),NOW()),
('address_type','Mailing Address','This is the address where the individual wants to receive mail. It might be different from the permanent or present address',1,NOW(),NOW()),
-- Phone type option
('phone_type','Mobile','This is the individual Mobile phone number.',1,NOW(),NOW()),
('phone_type','Office','This is the Office phone number',1,NOW(),NOW()),
('phone_type','Home','This is the home phone number. It might be land or mobile phone',1,NOW(),NOW()),
-- Gender options
('gender', 'Male','Male',1,NOW(), NOW()),
('gender', 'Female','Female',1,NOW(), NOW()),
('gender', 'Other','Other',1,NOW(), NOW()),
-- contact us options
('contact_us', 'General Inquiry','A request for information or assistance that does not fall into a specific category.',1,NOW(), NOW()),
('contact_us','Customer Support','Assistance provided to customers regarding product or service-related inquiries or issues.',1,NOW(), NOW()),
('contact_us','Technical Support','Assistance provided to address technical issues or challenges with a product or service.',1,NOW(), NOW()),
('contact_us','Feedback or Suggestions','Comments or recommendations provided to improve or enhance products, services, or processes.',1,NOW(), NOW()),
('contact_us','Report a Bug','Notification of a technical glitch or issue in a product or service that needs attention.',1,NOW(), NOW()),
('contact_us','Partnership Opportunities','Inquiries or proposals related to forming partnerships or collaborations.',1,NOW(), NOW()),
('contact_us','Media Inquiries','Requests from media outlets seeking information or interviews.',1,NOW(), NOW()),
('contact_us','Advertising Inquiries','Inquiries related to advertising opportunities or campaigns.',1,NOW(), NOW()),
('contact_us','Collaboration Requests','Requests for joint ventures, cooperative projects, or partnerships.',1,NOW(), NOW()),
('contact_us','Employment Opportunities','Inquiries or applications for job openings or employment opportunities.',1,NOW(), NOW()),
('contact_us','Website/App Feedback','Comments or suggestions specifically related to the website or application.',1,NOW(), NOW()),
('contact_us','Content Submission','Submissions of content, articles, or materials for consideration or publication.',1,NOW(), NOW()),
('contact_us','Privacy Concerns','Issues or inquiries related to privacy policies or data protection.',1,NOW(), NOW()),
('contact_us','Legal Inquiries','Requests for legal information or assistance.',1,NOW(), NOW()),
('contact_us','Other (please specify)','Any inquiry or request that does not fit into the predefined categories. Please specify the nature of the inquiry.',1,NOW(), NOW()),
-- Family Reference
('family','Father','The male parent of a child',1,NOW(),NOW()),
('family','Mother','The female parent of a child',1,NOW(),NOW()),
('family','Brother','A male sibling',1,NOW(),NOW()),
('family','Sister','A female sibling',1,NOW(),NOW()),
('family','Uncle','The brother of one\'s parent',1,NOW(),NOW()),
('family','Aunt','The sister of one\'s parent',1,NOW(),NOW()),
('family','Grandfather','The father of one\'s parent',1,NOW(),NOW()),
('family','Grandmother','The mother of one\'s parent',1,NOW(),NOW()),
('reference','Friend','A person with whom one has a bond of mutual affection',1,NOW(),NOW()),
('reference','Colleague','A person one works with',1,NOW(),NOW()),
('reference','Mentor','An experienced and trusted advisor',1,NOW(),NOW()),
('reference','Neighbor','A person living near or next door',1,NOW(),NOW()),
('reference','Supervisor','A person who oversees others at work',1,NOW(),NOW()),
('reference','Coach','A person who trains and instructs others',1,NOW(),NOW()),
('reference','Cousin','The mother/father\'s brother/sister son/daughter',1,NOW(),NOW()),
('reference','Distant relative','A person who is not a direct relative but distant',1,NOW(),NOW()),
-- Freind

('freind','Close Friends','Friends with a deep and intimate connection, often sharing personal thoughts and feelings.',1,NOW(), NOW()),
('freind','Childhood Friends','Friends from early years of life, typically from elementary or primary school.',1,NOW(), NOW()),
('freind','Work Friends','Friends made in a professional or workplace setting.',1,NOW(), NOW()),
('freind','School Friends','Friends from the educational setting, excluding higher education.',1,NOW(), NOW()),
('freind','College Friends','Friends from the higher education setting, typically from a college or university.',1,NOW(), NOW()),
('freind','Neighbors','Friends who live in close proximity, often in the same neighborhood.',1,NOW(), NOW()),
('freind','Casual Friends','Friends with a relaxed and informal connection.',1,NOW(), NOW()),
('freind','Best Friends','Very close and trusted friends, often considered as the closest confidantes.',1,NOW(), NOW()),
('freind','Online Friends','Friends made through online platforms and social media.',1,NOW(), NOW()),
('freind','Long-Distance Friends','Friends who maintain a friendship despite being geographically distant.',1,NOW(), NOW()),
('freind','Gym Buddies','Friends with whom one exercises and goes to the gym.',1,NOW(), NOW()),
('freind','Hobby Buddies','Friends who share common hobbies and interests.',1,NOW(), NOW()),
('freind','Travel Companions','Friends with whom one travels and explores new places.',1,NOW(), NOW()),
('freind','Study Partners','Friends who collaborate on academic studies and assignments.',1,NOW(), NOW()),
('freind','Pen Pals','Friends who exchange letters and communication through written correspondence.',1,NOW(), NOW()),
('freind','Activity Friends','Friends with whom one engages in specific activities.',1,NOW(), NOW()),
('freind','Supportive Friends','Friends who provide emotional and practical support.',1,NOW(), NOW()),
('freind','Adventurous Friends','Friends who enjoy taking risks and seeking new experiences together.',1,NOW(), NOW()),
('freind','Party Friends','Friends with whom one socializes and attends parties and events.',1,NOW(), NOW()),
('freind','Foodie Friends','Friends who share a love for food and enjoy dining together.',1,NOW(), NOW()),
('freind','Coffee Buddies','Friends with whom one enjoys coffee and casual conversations.',1,NOW(), NOW()),
('freind','Book Club Friends','Friends who participate in a book club and discuss literature together.',1,NOW(), NOW()),
('freind','Gaming Pals','Friends who share an interest in gaming and play video or board games together.',1,NOW(), NOW()),
('freind','Artistic Companions','Friends who appreciate and engage in artistic and creative pursuits together.',1,NOW(), NOW()),
('freind','Professional Network','Friends who are part of a professional or business network.',1,NOW(), NOW()),
-- Marital Status
('marital_status','Single','An unmarried person who has never been married.',1,NOW(), NOW()),
('marital_status','Married','A legally recognized union between two individuals.',1,NOW(), NOW()),
('marital_status','Divorced','The legal dissolution of a marriage.',1,NOW(), NOW()),
('marital_status','Widowed','The state of having lost one\'s spouse through death.',1,NOW(), NOW()),
('marital_status','Separated','Living apart from one\'s spouse without getting divorced.',1,NOW(), NOW()),
('marital_status','In a Relationship','Two people who are romantically or sexually involved with each other but may not be married.',1,NOW(), NOW()),
('marital_status','Engaged','A formal agreement to get married.',1,NOW(), NOW()),
('marital_status','Domestic Partnership','A legal relationship between two individuals who live together and share a domestic life together.',1,NOW(), NOW()),
('marital_status','Civil Union','A legal status similar to marriage with varying legal rights.',1,NOW(), NOW()),
('marital_status','Common-Law Marriage','A marriage recognized in some jurisdictions formed by the parties living together and holding themselves out as a married couple.',1,NOW(), NOW()),
('marital_status','Annulled','A legal declaration that a marriage is null and void, as if it had never taken place.',1,NOW(), NOW()),

-- Profession

('profession','Accountant','A professional responsible for financial record-keeping, analysis, and reporting.',1,NOW(), NOW()),
('profession','Actor/Actress','An individual who performs on stage, in films, or on television.',1,NOW(), NOW()),
('profession','Architect','A professional involved in the planning, design, and oversight of building structures.',1,NOW(), NOW()),
('profession','Artist','A person skilled in one of the fine arts, such as painting, sculpture, or music.',1,NOW(), NOW()),
('profession','Attorney/Lawyer','A legal professional providing advice, representation, and advocacy in legal matters.',1,NOW(), NOW()),
('profession','Baker','A person who bakes and sells bread, cakes, and pastries.',1,NOW(), NOW()),
('profession','Barista','A person who prepares and serves coffee, often in a coffee shop.',1,NOW(), NOW()),
('profession','Biologist','A scientist specializing in the study of living organisms and their interactions.',1,NOW(), NOW()),
('profession','Chef','A professional cook skilled in the preparation of food.',1,NOW(), NOW()),
('profession','Civil Engineer','An engineer involved in the planning and design of civil infrastructure projects.',1,NOW(), NOW()),
('profession','Content Creator','An individual who produces and publishes digital content, often on social media platforms.',1,NOW(), NOW()),
('profession','Data Scientist','A professional who analyzes and interprets complex data sets to inform business decisions.',1,NOW(), NOW()),
('profession','Dentist','A medical professional specializing in the treatment of oral health issues.',1,NOW(), NOW()),
('profession','Doctor/Physician','A medical professional qualified to practice medicine, diagnose illnesses, and prescribe treatments.',1,NOW(), NOW()),
('profession','Electrician','A skilled tradesperson who installs, repairs, and maintains electrical systems.',1,NOW(), NOW()),
('profession','Engineer','A professional trained in various branches of engineering.',1,NOW(), NOW()),
('profession','Fashion Designer','A professional who designs clothing and accessories.',1,NOW(), NOW()),
('profession','Financial Analyst','A professional who analyzes financial data to provide insights and recommendations.',1,NOW(), NOW()),
('profession','Graphic Designer','A professional who creates visual content for print and digital media.',1,NOW(), NOW()),
('profession','Hair Stylist','A professional trained in cutting, coloring, and styling hair.',1,NOW(), NOW()),
('profession','IT Professional','A professional working in the field of information technology.',1,NOW(), NOW()),
('profession','Journalist','A person who gathers, writes, and reports news for media outlets.',1,NOW(), NOW()),
('profession','Marketing Specialist','A professional specializing in promoting and selling products or services.',1,NOW(), NOW()),
('profession','Musician','A person skilled in playing a musical instrument or singing.',1,NOW(), NOW()),
('profession','Nurse','A healthcare professional providing care and support to patients.',1,NOW(), NOW()),
('profession','Nutritionist','A professional specializing in the study of nutrition and dietary practices.',1,NOW(), NOW()),
('profession','Paramedic','A healthcare professional trained to provide emergency medical care.',1,NOW(), NOW()),
('profession','Pharmacist','A healthcare professional responsible for dispensing medications and providing advice on their use.',1,NOW(), NOW()),
('profession','Photographer','A person who captures and creates images using a camera.',1,NOW(), NOW()),
('profession','Pilot','A person trained to operate an aircraft.',1,NOW(), NOW()),
('profession','Police Officer','A law enforcement professional responsible for maintaining public safety and enforcing laws.',1,NOW(), NOW()),
('profession','Professor/Teacher','An educator who imparts knowledge and skills to students.',1,NOW(), NOW()),
('profession','Psychologist','A professional trained in the study of the human mind and behavior.',1,NOW(), NOW()),
('profession','Real Estate Agent','A professional involved in the buying and selling of real estate.',1,NOW(), NOW()),
('profession','Research Scientist','A scientist engaged in research and experimentation.',1,NOW(), NOW()),
('profession','Sales Representative','A professional responsible for selling products or services.',1,NOW(), NOW()),
('profession','Social Worker','A professional providing support and services to individuals and communities.',1,NOW(), NOW()),
('profession','Software Developer','A professional involved in the design and creation of computer software.',1,NOW(), NOW()),
('profession','Speech Therapist','A healthcare professional specializing in speech and language therapy.',1,NOW(), NOW()),
('profession','Surgeon','A medical professional trained to perform surgical procedures.',1,NOW(), NOW()),
('profession','Surveyor','A professional responsible for measuring and mapping land.',1,NOW(), NOW()),
('profession','Taxi Driver','A person who drives a taxi to transport passengers.',1,NOW(), NOW()),
('profession','Teacher','An educator who imparts knowledge and skills to students.',1,NOW(), NOW()),
('profession','Technician','A skilled worker who specializes in a particular field or industry.',1,NOW(), NOW()),
('profession','Translator','A professional who translates written or spoken content from one language to another.',1,NOW(), NOW()),
('profession','Travel Agent','A professional who assists individuals in planning and booking travel.',1,NOW(), NOW()),
('profession','Truck Driver','A person who drives trucks to transport goods.',1,NOW(), NOW()),
('profession','Veterinarian','A medical professional specializing in the health and care of animals.',1,NOW(), NOW()),
('profession','Waiter/Waitress','A person who serves food and beverages to customers in a restaurant.',1,NOW(), NOW()),
('profession','Web Developer','A professional involved in the design and development of websites.',1,NOW(), NOW()),
-- Religion
 ('religion','Christian','A monotheistic Abrahamic religion based on the life and teachings of Jesus Christ.',1,NOW(), NOW()),
 ('religion','Islam','A monotheistic Abrahamic religion based on the teachings of the Prophet Muhammad and the Quran.',1,NOW(), NOW()),
 ('religion','Hindu','A major religious and cultural tradition of South Asia, characterized by a diverse range of beliefs and practices.',1,NOW(), NOW()),
 ('religion','Buddhism','A non-theistic religion or philosophy that encompasses a variety of traditions based on the teachings of Siddhartha Gautama.',1,NOW(), NOW()),
 ('religion','Sikh','A monotheistic religion founded on the teachings of Guru Nanak and the ten successive Sikh Gurus.',1,NOW(), NOW()),
 ('religion','Judaism','A monotheistic Abrahamic religion based on the covenant between God and the patriarch Abraham, as revealed in the Hebrew Bible.',1,NOW(), NOW()),
 ('religion','Bahá\'í Faith','A monotheistic religion founded by Bahá\'u\'lláh, emphasizing the spiritual unity of all humankind.',1,NOW(), NOW()),
 ('religion','Jainism','An ancient Indian religion emphasizing non-violence, truth, and asceticism.',1,NOW(), NOW()),
 ('religion','Shinto','The traditional religion of Japan, involving the worship of kami (spirits) and rituals at shrines.',1,NOW(), NOW()),
 ('religion','Taoism','A Chinese philosophy and religion centered on the Tao (the Way) and the concept of balancing opposites.',1,NOW(), NOW()),
 ('religion','Zoroastrianism','One of the world\'s oldest monotheistic religions, founded by the prophet Zoroaster, emphasizing the battle between good and evil.',1,NOW(), NOW()),
 
 -- Disability
 ('disability','Vision Impairment','A condition that affects the eyesight, ranging from partial to complete loss of vision.',1,NOW(), NOW()),
 ('disability','Hearing Impairment','A partial or complete inability to hear.',1,NOW(), NOW()),
 ('disability','Mobility Impairment','A condition that affects a person\'s ability to move freely.',1,NOW(), NOW()),
 ('disability','Cognitive Impairment','A condition that affects cognitive functions such as memory, attention, and problem-solving.',1,NOW(), NOW()),
 ('disability','Speech Impairment','A condition that affects the ability to produce sounds that create clear and effective communication.',1,NOW(), NOW()),
 ('disability','Deaf-Blindness','A combined hearing and vision impairment that causes difficulties in communication and accessing information.',1,NOW(), NOW()),
 ('disability','Autism Spectrum Disorder','A neurodevelopmental disorder characterized by challenges in social interaction and communication, and restricted and repetitive behaviors.',1,NOW(), NOW()),
 ('disability','Intellectual Disability','A condition characterized by limitations in intellectual functioning and adaptive behavior.',1,NOW(), NOW()),
 ('disability','Psychiatric Disability','A condition that affects mental health and may impact emotions, thoughts, and behaviors.',1,NOW(), NOW()),
 ('disability','Learning Disability','A condition that affects the ability to acquire and use academic and/or social skills at the expected level.',1,NOW(), NOW()),
 ('disability','Dyslexia','A specific learning disability that impacts reading, spelling, and writing skills.',1,NOW(), NOW()),
 ('disability','Attention Deficit Hyperactivity Disorder (ADHD)','A neurodevelopmental disorder characterized by persistent patterns of inattention, hyperactivity, and impulsivity.',1,NOW(), NOW()),
 ('disability','Down Syndrome','A genetic disorder caused by the presence of an extra chromosome 21, resulting in physical and intellectual delays.',1,NOW(), NOW()),
 ('disability','Cerebral Palsy','A group of disorders affecting movement and coordination caused by damage to the brain during development.',1,NOW(), NOW()),
 ('disability','Multiple Sclerosis','A chronic autoimmune disease that affects the central nervous system, leading to varied symptoms.',1,NOW(), NOW()),
 ('disability','Muscular Dystrophy','A group of genetic disorders characterized by progressive muscle weakness and degeneration.',1,NOW(), NOW()),
 ('disability','Chronic Fatigue Syndrome','A complex disorder characterized by extreme fatigue that does not improve with rest and may be worsened by physical or mental activity.',1,NOW(), NOW()),
 ('disability','Epilepsy','A neurological disorder characterized by recurrent seizures caused by abnormal brain activity.',1,NOW(), NOW()),
 ('disability','Rheumatoid Arthritis','An autoimmune disorder that causes chronic inflammation of the joints, leading to pain, swelling, and joint damage.',1,NOW(), NOW()),
 ('disability','Fibromyalgia','A disorder characterized by widespread musculoskeletal pain, fatigue, and tenderness in localized areas.',1,NOW(), NOW()),
 ('disability','Amputation','The removal of a body part, usually an extremity, due to injury, disease, or surgery.',1,NOW(), NOW()),
 ('disability','Spinal Cord Injury','Damage to the spinal cord resulting in a loss of function, often causing paralysis.',1,NOW(), NOW()),
 ('disability','Traumatic Brain Injury (TBI)','A sudden injury to the brain caused by an external force, leading to cognitive and physical impairment.',1,NOW(), NOW()),
 ('disability','Diabetes-related Disability','Complications related to diabetes that may impact various aspects of health and functioning.',1,NOW(), NOW()),
 ('disability','Chronic Pain Disorder','Persistent pain that may last for an extended period and can impact physical and mental well-being.',1,NOW(), NOW()),
 -- Nationlaity
 ('nationality','Indian','Person from India, a large country in South Asia with diverse cultures, languages, and a long history.',1,NOW(), NOW()),
 ('nationality','Canadian','Person from Canada, the second-largest country in the world, located in North America.',1,NOW(), NOW()),
 ('nationality','American','Person from the United States, a country located in North America, known for its diverse culture and global influence.',1,NOW(), NOW()),
 
 -- Caste
('caste','Brahmin','A member of the highest Hindu caste, traditionally a priest or scholar.',1,NOW(), NOW()),
('caste','Kshatriya','A member of the second-highest Hindu caste, traditionally warriors and rulers.',1,NOW(), NOW()),
('caste','Vaishya','A member of the third-highest Hindu caste, traditionally merchants and landowners.',1,NOW(), NOW()),
('caste','Shudra','A member of the fourth and lowest Hindu caste, traditionally servants and laborers.',1,NOW(), NOW()),
('caste','Agarwal','A community associated with business and trade in the Indian subcontinent.',1,NOW(), NOW()),
('caste','Ahir','A community traditionally associated with cattle-herding and farming.',1,NOW(), NOW()),
('caste','Arora','A Punjabi community engaged in trade and commerce.',1,NOW(), NOW()),
('caste','Balija/Goud','A community found in Southern India, traditionally engaged in agriculture and business.',1,NOW(), NOW()),
('caste','Bania','A merchant community engaged in trade and commerce.',1,NOW(), NOW()),
('caste','Bunt','A community found in coastal Karnataka, India, engaged in agriculture and business.',1,NOW(), NOW()),
('caste','Chettiar','A mercantile and business community in Tamil Nadu, India.',1,NOW(), NOW()),
('caste','Chettiar','Another community with the same name, traditionally engaged in trade and commerce.',1,NOW(), NOW()),
('caste','Devar','A community found in Southern India, engaged in various occupations including agriculture.',1,NOW(), NOW()),
('caste','Garhwali','An ethnic group from the Garhwal region of the Indian state of Uttarakhand.',1,NOW(), NOW()),
('caste','Goundar','A community traditionally associated with agriculture and trade.',1,NOW(), NOW()),
('caste','Gounder','Another community with a similar name, traditionally engaged in agriculture and business.',1,NOW(), NOW()),
('caste','Gujjar','A pastoral and agricultural community found in India and Pakistan.',1,NOW(), NOW()),
('caste','Gupta','A community historically associated with administrative and business roles.',1,NOW(), NOW()),
('caste','Iyengar','A subsect of the Brahmin community, primarily based in Southern India.',1,NOW(), NOW()),
('caste','Iyer','Another subsect of the Brahmin community, primarily based in Southern India.',1,NOW(), NOW()),
('caste','Jat','A community traditionally associated with agriculture and military service.',1,NOW(), NOW()),
('caste','Jat Sikh','A Sikh sub-group of the Jat community, known for their agricultural background.',1,NOW(), NOW()),
('caste','Kalar','A community traditionally engaged in various occupations including agriculture.',1,NOW(), NOW()),
('caste','Kamma','A community found in Southern India, traditionally engaged in agriculture and trade.',1,NOW(), NOW()),
('caste','Kamma Naidu','A subsect of the Kamma community with a similar background.',1,NOW(), NOW()),
('caste','Kapu','A community found in Southern India, engaged in agriculture and business.',1,NOW(), NOW()),
('caste','Kapu Naidu','A subsect of the Kapu community with a similar background.',1,NOW(), NOW()),
('caste','Kayastha','A community historically associated with administrative and literary roles.',1,NOW(), NOW()),
('caste','Khandelwal','A business community known for trade and commerce.',1,NOW(), NOW()),
('caste','Khatri','A Punjabi trading community traditionally engaged in business.',1,NOW(), NOW()),
('caste','Khokhar','A community found in Northern India, traditionally engaged in agriculture.',1,NOW(), NOW()),
('caste','Kori','A community engaged in various occupations including agriculture and trade.',1,NOW(), NOW()),
('caste','Kumaoni','An ethnic group from the Kumaon region of the Indian state of Uttarakhand.',1,NOW(), NOW()),
('caste','Labana','A Sikh trading and farming community.',1,NOW(), NOW()),
('caste','Lingayat','A community in Southern India with a distinct religious identity.',1,NOW(), NOW()),
('caste','Maheshwari','A business community known for trade and commerce.',1,NOW(), NOW()),
('caste','Maratha','A martial community from the western Indian state of Maharashtra.',1,NOW(), NOW()),
('caste','Mazhabi','A Sikh community historically associated with the military.',1,NOW(), NOW()),
('caste','Meena','An indigenous community found in Rajasthan, India.',1,NOW(), NOW()),
('caste','Menon','A Kerala-based community with diverse occupations.',1,NOW(), NOW()),
('caste','Mudaliar','A Tamil-speaking community engaged in trade and commerce.',1,NOW(), NOW()),
('caste','Mudaliar','Another community with the same name, traditionally engaged in trade and commerce.',1,NOW(), NOW()),
('caste','Nadar','A community found in Southern India, engaged in various occupations including business.',1,NOW(), NOW()),
('caste','Naidu','A title used by various communities in Southern India, indicating social standing.',1,NOW(), NOW()),
('caste','Nair','A community from the Indian state of Kerala, historically associated with various roles.',1,NOW(), NOW()),
('caste','Parsi','A Zoroastrian community that migrated to India from Persia.',1,NOW(), NOW()),
('caste','Patel','A title used by various agricultural and business communities in India.',1,NOW(), NOW()),
('caste','Pillai','A Tamil-speaking community historically engaged in trade and administration.',1,NOW(), NOW()),
('caste','Rajput','A martial community historically associated with ruling princely states.',1,NOW(), NOW()),
('caste','Ramgharia','A Sikh community known for carpentry, blacksmithing, and related trades.',1,NOW(), NOW()),
('caste','Ravidasia','A Sikh community historically associated with leatherwork.',1,NOW(), NOW()),
('caste','Reddy','A community found in Southern India, traditionally engaged in agriculture and business.',1,NOW(), NOW()),
('caste','Sindhi','An ethnic group with a diverse range of occupations, historically associated with Sindh.',1,NOW(), NOW()),
('caste','Teli','A business community traditionally associated with oil pressing and trade.',1,NOW(), NOW()),
('caste','Thakur','A title used by various communities, often indicating a landowning or warrior status.',1,NOW(), NOW()),
('caste','Valmiki','A community historically associated with the occupation of sweeping and sanitation.',1,NOW(), NOW()),
('caste','Vanniyar','A community found in Southern India, traditionally engaged in agriculture and trade.',1,NOW(), NOW()),
('caste','Velama','A community found in Southern India, traditionally engaged in agriculture and trade.',1,NOW(), NOW()),
('caste','Vokkaliga','A community found in Southern India, traditionally engaged in agriculture.',1,NOW(), NOW()),
('caste','Yadav','A community traditionally associated with agriculture and animal husbandry.',1,NOW(), NOW()) ,


-- FIELD OF STUDY 
-- Computer Science & IT Fields
('field_of_study', 'Computer Science', 'Study of computation, algorithms, and information systems', 1, NOW(), NOW()),
('field_of_study', 'Information Technology', 'Study of computer systems and networks for business applications', 1, NOW(), NOW()),
('field_of_study', 'Software Engineering', 'Engineering principles applied to software development', 1, NOW(), NOW()),
('field_of_study', 'Data Science', 'Extracting knowledge from structured and unstructured data', 1, NOW(), NOW()),

-- Engineering Fields
('field_of_study', 'Electrical Engineering', 'Study of electricity, electronics, and electromagnetism', 1, NOW(), NOW()),
('field_of_study', 'Mechanical Engineering', 'Design and manufacture of mechanical systems', 1, NOW(), NOW()),
('field_of_study', 'Civil Engineering', 'Design and construction of infrastructure projects', 1, NOW(), NOW()),
('field_of_study', 'Chemical Engineering', 'Application of chemistry to industrial processes', 1, NOW(), NOW()),

-- Business & Economics
('field_of_study', 'Business Administration', 'Management and operation of business organizations', 1, NOW(), NOW()),
('field_of_study', 'Economics', 'Study of production, distribution, and consumption of goods', 1, NOW(), NOW()),
('field_of_study', 'Finance', 'Management of money and investments', 1, NOW(), NOW()),
('field_of_study', 'Marketing', 'Process of promoting and selling products/services', 1, NOW(), NOW()),

-- Health Sciences
('field_of_study', 'Medicine', 'Science and practice of diagnosing and treating disease', 1, NOW(), NOW()),
('field_of_study', 'Nursing', 'Care for individuals to maintain or recover health', 1, NOW(), NOW()),
('field_of_study', 'Pharmacy', 'Preparation and dispensing of medicinal drugs', 1, NOW(), NOW()),
('field_of_study', 'Public Health', 'Protecting and improving community health', 1, NOW(), NOW()),

-- Natural Sciences
('field_of_study', 'Biology', 'Study of living organisms', 1, NOW(), NOW()),
('field_of_study', 'Chemistry', 'Study of matter and its interactions', 1, NOW(), NOW()),
('field_of_study', 'Physics', 'Study of matter, energy, and their interactions', 1, NOW(), NOW()),
('field_of_study', 'Mathematics', 'Study of numbers, quantities, and shapes', 1, NOW(), NOW()),

-- Social Sciences & Humanities
('field_of_study', 'Psychology', 'Scientific study of the human mind and behavior', 1, NOW(), NOW()),
('field_of_study', 'Sociology', 'Study of human society and social relationships', 1, NOW(), NOW()),
('field_of_study', 'Political Science', 'Study of political systems and behavior', 1, NOW(), NOW()),
('field_of_study', 'History', 'Study of past events and their impact', 1, NOW(), NOW()),

-- Arts & Design
('field_of_study', 'Fine Arts', 'Creative art, especially visual art', 1, NOW(), NOW()),
('field_of_study', 'Graphic Design', 'Visual communication through design', 1, NOW(), NOW()),
('field_of_study', 'Architecture', 'Art and science of building design', 1, NOW(), NOW()),
('field_of_study', 'Performing Arts', 'Art forms performed for an audience', 1, NOW(), NOW()),

-- Education
('field_of_study', 'Early Childhood Education', 'Teaching young children (0-8 years)', 1, NOW(), NOW()),
('field_of_study', 'Special Education', 'Education for students with special needs', 1, NOW(), NOW()),
('field_of_study', 'Educational Leadership', 'Administration and leadership in education', 1, NOW(), NOW()),

-- Emerging Fields
('field_of_study', 'Artificial Intelligence', 'Development of intelligent machines', 1, NOW(), NOW()),
('field_of_study', 'Cybersecurity', 'Protection of computer systems from theft/damage', 1, NOW(), NOW()),
('field_of_study', 'Environmental Science', 'Study of environmental problems and solutions', 1, NOW(), NOW()),


-- EDUCATION LEVEL
-- Primary/Elementary Education
('education_level', 'No Formal Education', 'Has not attended formal schooling', 1, NOW(), NOW()),
('education_level', 'Primary School', 'Elementary education (typically grades 1-5/6)', 1, NOW(), NOW()),
('education_level', 'Middle School', 'Education between primary and high school (grades 6-8)', 1, NOW(), NOW()),

-- Secondary Education
('education_level', 'High School Diploma', 'Completed secondary education', 1, NOW(), NOW()),
('education_level', 'GED', 'General Educational Development certificate', 1, NOW(), NOW()),
('education_level', 'Vocational Certificate', 'Completed vocational training program', 1, NOW(), NOW()),

-- Undergraduate Levels
('education_level', 'Some College', 'Attended college but no degree', 1, NOW(), NOW()),
('education_level', 'Associate Degree', '2-year college degree', 1, NOW(), NOW()),
('education_level', 'Bachelor\'s Degree', '4-year college degree', 1, NOW(), NOW()),
('education_level', 'Honours Degree', 'Bachelor\'s with honors designation', 1, NOW(), NOW()),

-- Graduate Levels
('education_level', 'Master\'s Degree', 'Postgraduate academic degree', 1, NOW(), NOW()),
('education_level', 'MBA', 'Master of Business Administration', 1, NOW(), NOW()),
('education_level', 'Professional Degree', 'Degree required for specific professions (JD, MD)', 1, NOW(), NOW()),

-- Doctoral Levels
('education_level', 'PhD', 'Doctor of Philosophy research degree', 1, NOW(), NOW()),
('education_level', 'Doctorate', 'Highest academic degree', 1, NOW(), NOW()),
('education_level', 'Postdoctoral', 'Research after completing a doctorate', 1, NOW(), NOW()),

-- International Equivalents
('education_level', 'Diploma', 'Vocational or technical qualification', 1, NOW(), NOW()),
('education_level', 'A Levels', 'UK advanced secondary qualification', 1, NOW(), NOW()),
('education_level', 'International Baccalaureate', 'International pre-university program', 1, NOW(), NOW()),

-- Special Cases
('education_level', 'Currently in High School', 'Currently attending secondary school', 1, NOW(), NOW()),
('education_level', 'Currently in College', 'Currently pursuing undergraduate degree', 1, NOW(), NOW()),
('education_level', 'Currently in Graduate School', 'Currently pursuing postgraduate degree', 1, NOW(), NOW()),


-- JOB TITLES
-- Executive/C-Suite
('job_title', 'CEO', 'Chief Executive Officer', 1, NOW(), NOW()),
('job_title', 'CFO', 'Chief Financial Officer', 1, NOW(), NOW()),
('job_title', 'CTO', 'Chief Technology Officer', 1, NOW(), NOW()),
('job_title', 'COO', 'Chief Operating Officer', 1, NOW(), NOW()),

-- Technology
('job_title', 'Software Engineer', 'Designs and develops software applications', 1, NOW(), NOW()),
('job_title', 'Data Scientist', 'Analyzes complex data to extract insights', 1, NOW(), NOW()),
('job_title', 'IT Manager', 'Oversees information technology department', 1, NOW(), NOW()),
('job_title', 'Systems Administrator', 'Manages computer systems and networks', 1, NOW(), NOW()),

-- Business/Finance
('job_title', 'Accountant', 'Manages financial records and reports', 1, NOW(), NOW()),
('job_title', 'Financial Analyst', 'Analyzes financial data for decision making', 1, NOW(), NOW()),
('job_title', 'HR Manager', 'Oversees human resources operations', 1, NOW(), NOW()),
('job_title', 'Business Analyst', 'Analyzes business processes and needs', 1, NOW(), NOW()),

-- Marketing/Sales
('job_title', 'Marketing Manager', 'Develops marketing strategies', 1, NOW(), NOW()),
('job_title', 'Sales Representative', 'Sells company products/services', 1, NOW(), NOW()),
('job_title', 'Digital Marketing Specialist', 'Manages online marketing campaigns', 1, NOW(), NOW()),
('job_title', 'Account Executive', 'Manages client accounts', 1, NOW(), NOW()),

-- Healthcare
('job_title', 'Physician', 'Medical doctor diagnosing/treating patients', 1, NOW(), NOW()),
('job_title', 'Registered Nurse', 'Provides patient care and support', 1, NOW(), NOW()),
('job_title', 'Pharmacist', 'Dispenses medications and advises patients', 1, NOW(), NOW()),

-- Education
('job_title', 'Teacher', 'Educates students in academic subjects', 1, NOW(), NOW()),
('job_title', 'Professor', 'Teaches at college/university level', 1, NOW(), NOW()),
('job_title', 'School Principal', 'Administers elementary/secondary school', 1, NOW(), NOW()),

-- Creative/Design
('job_title', 'Graphic Designer', 'Creates visual content', 1, NOW(), NOW()),
('job_title', 'Content Writer', 'Creates written content for various media', 1, NOW(), NOW()),
('job_title', 'UX/UI Designer', 'Designs user interfaces and experiences', 1, NOW(), NOW()),

-- Operations
('job_title', 'Operations Manager', 'Oversees company operations', 1, NOW(), NOW()),
('job_title', 'Project Manager', 'Leads projects to completion', 1, NOW(), NOW()),
('job_title', 'Logistics Coordinator', 'Manages supply chain operations', 1, NOW(), NOW()),

-- Customer Service
('job_title', 'Customer Service Representative', 'Assists customers with inquiries', 1, NOW(), NOW()),
('job_title', 'Technical Support Specialist', 'Provides technical assistance', 1, NOW(), NOW()),

-- Other Common Titles
('job_title', 'Consultant', 'Provides expert advice professionally', 1, NOW(), NOW()),
('job_title', 'Administrative Assistant', 'Provides clerical support', 1, NOW(), NOW()),
('job_title', 'Research Scientist', 'Conducts scientific research', 1, NOW(), NOW()),

-- Generic/Catch-all
('job_title', 'Intern', 'Trainee position for students/graduates', 1, NOW(), NOW()),
('job_title', 'Freelancer', 'Self-employed independent contractor', 1, NOW(), NOW()),
('job_title', 'Other', 'Job title not listed in options', 1, NOW(), NOW()),


-- EMPLOYMENT STATUS
-- Primary employment statuses
('employment_status', 'Employed (Full-time)', 'Working 35+ hours per week for a single employer', 1, NOW(), NOW()),
('employment_status', 'Employed (Part-time)', 'Working fewer than 35 hours per week', 1, NOW(), NOW()),
('employment_status', 'Self-employed', 'Operating one\'s own business or freelance work', 1, NOW(), NOW()),
('employment_status', 'Unemployed', 'Currently not working but seeking employment', 1, NOW(), NOW()),
('employment_status', 'Student', 'Primarily engaged in education', 1, NOW(), NOW()),
('employment_status', 'Retired', 'Permanently left the workforce', 1, NOW(), NOW()),

-- Specific work arrangements
('employment_status', 'Contractor', 'Working on fixed-term contracts', 1, NOW(), NOW()),
('employment_status', 'Temporary Worker', 'Employed for a limited duration', 1, NOW(), NOW()),
('employment_status', 'Intern', 'Engaged in temporary work experience', 1, NOW(), NOW()),
('employment_status', 'Apprentice', 'Learning a trade while working', 1, NOW(), NOW()),

-- Non-traditional statuses
('employment_status', 'Freelancer', 'Working independently for multiple clients', 1, NOW(), NOW()),
('employment_status', 'Gig Worker', 'Engaged in platform-based temporary work', 1, NOW(), NOW()),
('employment_status', 'Volunteer', 'Working without pay for an organization', 1, NOW(), NOW()),

-- Transitional statuses
('employment_status', 'On Leave', 'Temporarily away from work (parental, medical, etc.)', 1, NOW(), NOW()),
('employment_status', 'Between Jobs', 'Transitioning between employment positions', 1, NOW(), NOW()),
('employment_status', 'Career Break', 'Taking extended time off from work', 1, NOW(), NOW()),

-- Military statuses
('employment_status', 'Active Duty Military', 'Currently serving in armed forces', 1, NOW(), NOW()),
('employment_status', 'Veteran', 'Former military personnel', 1, NOW(), NOW()),
('employment_status', 'Military Spouse', 'Partner of active duty service member', 1, NOW(), NOW()),

-- Special cases
('employment_status', 'Disabled', 'Unable to work due to disability', 1, NOW(), NOW()),
('employment_status', 'Homemaker', 'Managing household without paid employment', 1, NOW(), NOW()),
('employment_status', 'Other', 'Employment status not listed', 1, NOW(), NOW()),

-- RELIGIONS
-- Major World Religions
('religion', 'Christianity', 'Abrahamic religion based on the life and teachings of Jesus Christ', 1, NOW(), NOW()),
('religion', 'Islam', 'Abrahamic religion articulated by the Quran and teachings of Muhammad', 1, NOW(), NOW()),
('religion', 'Hinduism', 'Indian religion and dharma, or way of life', 1, NOW(), NOW()),
('religion', 'Buddhism', 'Indian religion encompassing a variety of traditions based on teachings of Buddha', 1, NOW(), NOW()),
('religion', 'Sikhism', 'Monotheistic religion founded in Punjab in the 15th century', 1, NOW(), NOW()),
('religion', 'Judaism', 'Abrahamic religion of the Jewish people', 1, NOW(), NOW()),

-- Other Religious Groups
('religion', 'Baháʼí Faith', 'Monotheistic religion emphasizing spiritual unity', 1, NOW(), NOW()),
('religion', 'Jainism', 'Ancient Indian religion prescribing non-violence', 1, NOW(), NOW()),
('religion', 'Shinto', 'Ethnic religion of Japan focusing on ritual practices', 1, NOW(), NOW()),
('religion', 'Taoism', 'Chinese philosophical and religious tradition', 1, NOW(), NOW()),

-- Denominations/Sects
('religion', 'Catholicism', 'Largest Christian church led by the Pope', 1, NOW(), NOW()),
('religion', 'Protestantism', 'Christian movement separate from the Catholic Church', 1, NOW(), NOW()),
('religion', 'Orthodox Christianity', 'Second largest Christian communion', 1, NOW(), NOW()),
('religion', 'Sunni Islam', 'Largest branch of Islam', 1, NOW(), NOW()),
('religion', 'Shia Islam', 'Second largest branch of Islam', 1, NOW(), NOW()),

-- Non-religious Options
('religion', 'Atheist', 'Does not believe in any deities', 1, NOW(), NOW()),
('religion', 'Agnostic', 'Believes existence of God is unknown or unknowable', 1, NOW(), NOW()),
('religion', 'Secular', 'Non-religious or neutral regarding religion', 1, NOW(), NOW()),
('religion', 'Humanist', 'Emphasizes human rather than divine matters', 1, NOW(), NOW()),

-- Indigenous/Other Belief Systems
('religion', 'Indigenous Religions', 'Traditional beliefs of native peoples', 1, NOW(), NOW()),
('religion', 'Zoroastrianism', 'One of the world\'s oldest monotheistic religions', 1, NOW(), NOW()),
('religion', 'Pagan', 'Contemporary nature-based spiritual paths', 1, NOW(), NOW()),
('religion', 'Spiritual but not Religious', 'Belief in spirituality without organized religion', 1, NOW(), NOW()),

-- Special Categories
('religion', 'Prefer Not to Say', 'Declines to specify religious affiliation', 1, NOW(), NOW()),
('religion', 'Other', 'Religious affiliation not listed', 1, NOW(), NOW()),


-- PROPERTY TYPES
-- Residential Properties
('property_type', 'Single Family Home', 'Detached residential dwelling', 1, NOW(), NOW()),
('property_type', 'Apartment', 'Unit within a multi-unit building', 1, NOW(), NOW()),
('property_type', 'Condominium', 'Individually owned unit in shared building', 1, NOW(), NOW()),
('property_type', 'Townhouse', 'Multi-floor attached home sharing walls', 1, NOW(), NOW()),
('property_type', 'Villa', 'Luxury detached residence', 1, NOW(), NOW()),
('property_type', 'Farm House', 'Rural residential property', 1, NOW(), NOW()),

-- Commercial Properties
('property_type', 'Office Space', 'Commercial work environment', 1, NOW(), NOW()),
('property_type', 'Retail Space', 'Commercial property for shops/stores', 1, NOW(), NOW()),
('property_type', 'Warehouse', 'Storage or distribution facility', 1, NOW(), NOW()),
('property_type', 'Industrial Property', 'Manufacturing or production facility', 1, NOW(), NOW()),

-- Special Purpose Properties
('property_type', 'Hotel/Resort', 'Commercial lodging property', 1, NOW(), NOW()),
('property_type', 'Healthcare Facility', 'Hospital or medical center', 1, NOW(), NOW()),
('property_type', 'Educational Institution', 'School or university property', 1, NOW(), NOW()),

-- Land Types
('property_type', 'Residential Plot', 'Land for housing construction', 1, NOW(), NOW()),
('property_type', 'Commercial Plot', 'Land for business development', 1, NOW(), NOW()),
('property_type', 'Agricultural Land', 'Land for farming activities', 1, NOW(), NOW()),
('property_type', 'Forest Land', 'Wooded or natural land', 1, NOW(), NOW()),

-- Other Property Types
('property_type', 'Mixed-Use Property', 'Combination residential/commercial', 1, NOW(), NOW()),
('property_type', 'Vacation Home', 'Secondary recreational residence', 1, NOW(), NOW()),
('property_type', 'Other', 'Property type not listed', 1, NOW(), NOW()),

-- OWNERSHIP TYPES

-- Individual Ownership Types
('ownership_type', 'Freehold', 'Absolute ownership of property and land', 1, NOW(), NOW()),
('ownership_type', 'Leasehold', 'Ownership for fixed term under lease', 1, NOW(), NOW()),
('ownership_type', 'Inherited', 'Property received through inheritance', 1, NOW(), NOW()),
('ownership_type', 'Gifted', 'Property received as gift', 1, NOW(), NOW()),

-- Shared Ownership Types
('ownership_type', 'Joint Tenancy', 'Equal shared ownership with rights of survivorship', 1, NOW(), NOW()),
('ownership_type', 'Tenancy in Common', 'Shared ownership without survivorship rights', 1, NOW(), NOW()),
('ownership_type', 'Community Property', 'Marital property ownership (in some jurisdictions)', 1, NOW(), NOW()),

-- Organizational Ownership
('ownership_type', 'Corporate Owned', 'Owned by business entity', 1, NOW(), NOW()),
('ownership_type', 'Government Owned', 'Owned by public authority', 1, NOW(), NOW()),
('ownership_type', 'Trust Owned', 'Held in a trust arrangement', 1, NOW(), NOW()),

-- Other Ownership Structures
('ownership_type', 'Cooperative', 'Owned by corporation with shareholder tenants', 1, NOW(), NOW()),
('ownership_type', 'Timeshare', 'Shared ownership of vacation property', 1, NOW(), NOW()),
('ownership_type', 'Other', 'Ownership type not listed', 1, NOW(), NOW()),



-- Hobbies
('hobby','Reading','Enjoying books, magazines, or other literature',1,NOW(),NOW()),
('hobby','Writing','Creative writing, blogging, or journaling',1,NOW(),NOW()),
('hobby','Photography','Capturing moments with a camera',1,NOW(),NOW()),
('hobby','Painting/Drawing','Visual arts and creative expression',1,NOW(),NOW()),
('hobby','Cooking/Baking','Preparing meals or desserts',1,NOW(),NOW()),
('hobby','Gardening','Cultivating plants and flowers',1,NOW(),NOW()),
('hobby','Playing Musical Instruments','Piano, guitar, violin, etc.',1,NOW(),NOW()),
('hobby','Singing','Vocal performance',1,NOW(),NOW()),
('hobby','Dancing','Various dance styles',1,NOW(),NOW()),
('hobby','Yoga/Meditation','Mind-body practices',1,NOW(),NOW()),
('hobby','Sports','Participating in athletic activities',1,NOW(),NOW()),
('hobby','Hiking','Outdoor walking in nature',1,NOW(),NOW()),
('hobby','Traveling','Exploring new places',1,NOW(),NOW()),
('hobby','Collecting','Stamps, coins, memorabilia, etc.',1,NOW(),NOW()),
('hobby','DIY Crafts','Handmade creations',1,NOW(),NOW()),
('hobby','Gaming','Video games or board games',1,NOW(),NOW()),
('hobby','Fishing','Recreational angling',1,NOW(),NOW()),
('hobby','Cycling','Bicycle riding',1,NOW(),NOW()),
('hobby','Swimming','Recreational or competitive swimming',1,NOW(),NOW()),
('hobby','Other','Specify your own hobby',1,NOW(),NOW()),

-- Interests
('interest','Technology','Computers, gadgets, and tech innovations',1,NOW(),NOW()),
('interest','Science','Scientific discoveries and research',1,NOW(),NOW()),
('interest','History','Historical events and periods',1,NOW(),NOW()),
('interest','Art','Visual arts and art history',1,NOW(),NOW()),
('interest','Music','Various music genres and artists',1,NOW(),NOW()),
('interest','Movies/Films','Cinema and filmmaking',1,NOW(),NOW()),
('interest','Theater','Stage performances and drama',1,NOW(),NOW()),
('interest','Literature','Books and literary works',1,NOW(),NOW()),
('interest','Fitness','Exercise and physical wellbeing',1,NOW(),NOW()),
('interest','Nutrition','Healthy eating and diets',1,NOW(),NOW()),
('interest','Psychology','Human mind and behavior',1,NOW(),NOW()),
('interest','Philosophy','Theoretical study of knowledge',1,NOW(),NOW()),
('interest','Astronomy','Space and celestial objects',1,NOW(),NOW()),
('interest','Environment','Ecology and sustainability',1,NOW(),NOW()),
('interest','Politics','Government and political affairs',1,NOW(),NOW()),
('interest','Economics','Financial systems and markets',1,NOW(),NOW()),
('interest','Fashion','Clothing and style trends',1,NOW(),NOW()),
('interest','Cars/Automobiles','Vehicles and automotive technology',1,NOW(),NOW()),
('interest','Animals/Pets','Care and appreciation of animals',1,NOW(),NOW()),
('interest','Other','Specify your own interest',1,NOW(),NOW())




;


INSERT INTO `lookup_table` (`name`, `description`, `category`) 
VALUES 
('email', 'Email - Primary email address', 'contact_type'),
('phone', 'Phone - Landline telephone number', 'contact_type'),
('mobile', 'Phone - Mobile phone number', 'contact_type'),
('facebook', 'Social - Facebook profile URL', 'contact_type'),
('twitter', 'Social - Twitter handle', 'contact_type'),
('linkedin', 'Professional - LinkedIn profile URL', 'contact_type'),
('instagram', 'Social - Instagram handle', 'contact_type'),
('skype', 'Communication - Skype username', 'contact_type'),
('whatsapp', 'Communication - WhatsApp phone number', 'contact_type'),
('telegram', 'Communicaiton - Telegram username', 'contact_type'),

('Clear Headshot', 'This picture will be displayed every where. Like Search, Profile default photo', 'photo_type'),
('Full-body shot', 'This helps provide a better perspective of your appearance and body language. Choose a relaxed setting, like outdoors, for a more natural feel.', 'photo_type'),
('Casual or Lifestyle Shot', 'A picture of you doing something you love, like traveling, reading, or playing a sport, will show your interests and hobbies.', 'photo_type'),
('Family Photo', 'A photo with family members (if appropriate) can give a sense of your familial bonds, showing you''re family-oriented', 'photo_type'),
('Candid or Fun Moment', 'A lighthearted photo of you laughing or enjoying time with friends might help balance out the more formal shots and show your personality.', 'photo_type'),
('Hobby or Activity Photo', 'If you''re passionate about something like cooking, painting, or playing a musical instrument, sharing a photo of you engaged in that can reveal more about who you are.', 'photo_type'),
('Other', 'Any other photo', 'photo_type');



