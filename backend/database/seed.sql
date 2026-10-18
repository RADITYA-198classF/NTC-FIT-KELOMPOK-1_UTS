USE ntc_fit_uts;

INSERT INTO categories(name) VALUES ('HIIT'),('Kekuatan'),('Yoga'),('Siap untuk Gym'),('Pilates');

INSERT INTO workouts(code,title,level,equipment,focus,minutes,image,description,is_new,sort_order) VALUES
('w1','Latihan Hybrid Pembangun Kekuatan untuk Lomba','Lanjut','Peralatan Lengkap','Kekuatan',45,'assets/images/barbell_deadlift.jpg','Kombinasi latihan kekuatan dan kondisi fisik untuk mempersiapkan tubuh menghadapi lomba hybrid.',1,1),
('w2','Inti Sirkuit Balap Hibrid 20 Menit','Lanjut','Peralatan Lengkap','Kekuatan',20,'assets/images/hybrid_floor_workout.jpg','Sirkuit singkat dan padat untuk membangun daya tahan dan kekuatan inti.',0,2),
('w3','Latihan Hybrid Kekuatan & Pembentukan 30 Menit','Lanjut','Peralatan Lengkap','Kekuatan',30,'assets/images/dumbbell_squat.jpg','Latihan seluruh tubuh dengan beban untuk membentuk otot sekaligus meningkatkan kekuatan.',0,3),
('w4','HIIT Pembakar Lemak 25 Menit','Menengah','Tanpa Peralatan','HIIT',25,'assets/images/hiit_red_training.jpg','Interval intensitas tinggi tanpa peralatan untuk meningkatkan kebugaran jantung.',0,4),
('w5','Yoga Pemulihan Seluruh Tubuh','Pemula','Matras','Yoga',30,'assets/images/plank_pose.jpg','Alur yoga lembut untuk melepas ketegangan otot dan membantu pemulihan.',0,5),
('w6','Pilates Inti dan Postur 20 Menit','Pemula','Matras','Pilates',20,'assets/images/core_plank.jpg','Latihan Pilates di matras untuk menguatkan otot inti dan memperbaiki postur.',0,6),
('w7','Dasar Latihan Beban untuk Gym','Pemula','Peralatan Lengkap','Kekuatan',40,'assets/images/metcon_barbell.jpg','Pengenalan gerakan dasar dengan barbel dan mesin untuk pemula di gym.',0,7),
('w8','Sirkuit HIIT Dumbel 15 Menit','Menengah','Dumbel','HIIT',15,'assets/images/kettlebell_squat.jpg','Sirkuit cepat dengan dumbel yang memadukan kekuatan dan kardio.',0,8),
('w9','Yoga Alur Pagi 20 Menit','Pemula','Matras','Yoga',20,'assets/images/group_workout.jpg','Alur yoga singkat untuk membangunkan tubuh dan menenangkan pikiran.',0,9),
('w10','Yoga Peregangan Pinggul 25 Menit','Menengah','Matras','Yoga',25,'assets/images/running_lunge.jpg','Rangkaian peregangan untuk melepas kekakuan di pinggul dan punggung bawah.',0,10),
('w11','Pilates Seluruh Tubuh 30 Menit','Menengah','Matras','Pilates',30,'assets/images/strength_dumbbell_row.webp','Latihan Pilates menyeluruh untuk kontrol, keseimbangan, dan kekuatan inti.',0,11),
('w12','Pilates Kaki dan Bokong 20 Menit','Pemula','Matras','Pilates',20,'assets/images/group_running.jpg','Fokus pada penguatan kaki dan bokong dengan gerakan terkendali.',0,12);

-- Pivot kategori
INSERT INTO category_workout(category_id, workout_id)
SELECT c.id,w.id FROM categories c JOIN workouts w WHERE
(c.name='Kekuatan' AND w.code IN ('w1','w2','w3','w7','w8')) OR
(c.name='Siap untuk Gym' AND w.code IN ('w1','w3','w7')) OR
(c.name='HIIT' AND w.code IN ('w1','w2','w4','w8')) OR
(c.name='Yoga' AND w.code IN ('w5','w9','w10')) OR
(c.name='Pilates' AND w.code IN ('w6','w11','w12'));

-- Exercise helper insert: setiap latihan memiliki gerakan agar sesi timer bisa didemokan.
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Cat Cow',10,NULL,'Lengkungkan punggung ke atas lalu turunkan perut sambil mengangkat dada.',1 FROM workouts WHERE code='w1';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Goblet Squat',12,NULL,'Pegang beban di depan dada, turunkan pinggul, lalu berdiri kembali.',2 FROM workouts WHERE code='w1';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Plank',NULL,40,'Jaga tubuh lurus dan kencangkan otot inti.',3 FROM workouts WHERE code='w1';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Jumping Jack',NULL,30,'Lompat sambil membuka kaki dan mengangkat lengan.',1 FROM workouts WHERE code='w2';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Mountain Climber',NULL,30,'Tarik lutut ke dada secara bergantian dari posisi plank tinggi.',2 FROM workouts WHERE code='w2';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Dead Bug',10,NULL,'Turunkan lengan dan kaki berlawanan dengan perut tetap kencang.',3 FROM workouts WHERE code='w2';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Goblet Squat',12,NULL,'Turunkan pinggul dengan dada tetap tegak.',1 FROM workouts WHERE code='w3';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Dumbbell Shoulder Press',10,NULL,'Dorong dumbel dari bahu hingga lengan lurus.',2 FROM workouts WHERE code='w3';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Glute Bridge',15,NULL,'Angkat pinggul hingga tubuh membentuk garis lurus.',3 FROM workouts WHERE code='w3';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Jumping Jack',NULL,30,'Buka-tutup kaki dan lengan dengan ritme stabil.',1 FROM workouts WHERE code='w4';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Squat Jump',10,NULL,'Turun ke squat lalu lompat dan mendarat lembut.',2 FROM workouts WHERE code='w4';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Burpee',8,NULL,'Turun ke push-up, kembali berdiri, lalu lompat.',3 FROM workouts WHERE code='w4';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Cat Cow',10,NULL,'Gerakkan tulang belakang perlahan mengikuti napas.',1 FROM workouts WHERE code='w5';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Downward Dog',NULL,30,'Angkat pinggul membentuk V terbalik.',2 FROM workouts WHERE code='w5';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Child''s Pose',NULL,30,'Duduk di tumit dan rentangkan lengan ke depan.',3 FROM workouts WHERE code='w5';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'The Hundred',NULL,30,'Ayunkan lengan kecil sambil menjaga inti aktif.',1 FROM workouts WHERE code='w6';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Roll Up',8,NULL,'Gulung tulang belakang naik dan turun dengan kontrol.',2 FROM workouts WHERE code='w6';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Plank',NULL,30,'Tahan posisi plank dengan tubuh lurus.',3 FROM workouts WHERE code='w6';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Barbell Back Squat',8,NULL,'Turunkan pinggul dengan dada tegak lalu berdiri.',1 FROM workouts WHERE code='w7';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Bench Press',8,NULL,'Turunkan barbel ke dada lalu dorong ke atas.',2 FROM workouts WHERE code='w7';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Lat Pulldown',10,NULL,'Tarik batang ke arah dada atas.',3 FROM workouts WHERE code='w7';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Goblet Squat',12,NULL,'Turunkan pinggul dan jaga beban dekat dada.',1 FROM workouts WHERE code='w8';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Shoulder Press',10,NULL,'Dorong dumbel ke atas dengan kontrol.',2 FROM workouts WHERE code='w8';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Mountain Climber',NULL,30,'Gerakkan lutut bergantian dengan cepat.',3 FROM workouts WHERE code='w8';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Sun Salutation',5,NULL,'Alirkan rangkaian gerakan mengikuti napas.',1 FROM workouts WHERE code='w9';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Warrior II',NULL,30,'Tekuk lutut depan dan rentangkan kedua lengan.',2 FROM workouts WHERE code='w9';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Child''s Pose',NULL,30,'Relakskan tubuh dan atur napas.',3 FROM workouts WHERE code='w9';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Pigeon Pose',NULL,40,'Turunkan dada perlahan untuk meregangkan pinggul.',1 FROM workouts WHERE code='w10';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'World''s Greatest Stretch',6,NULL,'Lunge, turunkan siku, lalu putar dada ke atas.',2 FROM workouts WHERE code='w10';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Child''s Pose',NULL,30,'Relakskan punggung dan pinggul.',3 FROM workouts WHERE code='w10';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'The Hundred',NULL,30,'Jaga inti aktif sambil memompa lengan.',1 FROM workouts WHERE code='w11';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Single Leg Stretch',10,NULL,'Ganti kaki secara bergantian dengan bahu terangkat.',2 FROM workouts WHERE code='w11';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Swimming',NULL,30,'Angkat dan ayunkan lengan-kaki bergantian.',3 FROM workouts WHERE code='w11';

INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Glute Bridge',15,NULL,'Angkat pinggul dan kencangkan bokong.',1 FROM workouts WHERE code='w12';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Side Leg Lift',12,NULL,'Angkat kaki atas setinggi pinggul.',2 FROM workouts WHERE code='w12';
INSERT INTO exercises(workout_id,name,reps,seconds,cue,sort_order)
SELECT id,'Reverse Lunge',10,NULL,'Langkahkan kaki ke belakang lalu kembali berdiri.',3 FROM workouts WHERE code='w12';
