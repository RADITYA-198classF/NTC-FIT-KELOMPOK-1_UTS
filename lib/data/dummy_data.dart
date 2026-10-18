import 'package:flutter/material.dart';

import 'models.dart';

/// Data contoh untuk keperluan UI. Ganti dengan data dari API pada tahap
/// integrasi backend. Judul, meta, dan durasi tiga latihan "Mode Hibrid"
/// sesuai referensi; deskripsi, daftar gerakan, dan latihan lain adalah isian
/// contoh yang bebas Anda ubah.

// ---------------------------------------------------------------------------
// Gerakan yang dipakai bersama
// ---------------------------------------------------------------------------
const Exercise _catCow = Exercise(
  'Cat Cow',
  reps: 10,
  cue: 'Mulai merangkak. Lengkungkan punggung ke atas, lalu turunkan perut sambil mengangkat dada.',
);
const Exercise _quadRocker = Exercise(
  'Quad Rocker',
  reps: 10,
  cue: 'Dari posisi merangkak, dorong pinggul ke belakang lalu kembali ke depan dengan punggung tetap lurus.',
);
const Exercise _worldsGreatest = Exercise(
  "World's Greatest Stretch",
  reps: 6,
  cue: 'Langkahkan satu kaki ke depan, turunkan siku ke dalam, lalu putar dada ke atas.',
);
const Exercise _gobletSquat = Exercise(
  'Goblet Squat',
  reps: 12,
  cue: 'Peluk beban di depan dada, turunkan pinggul hingga paha sejajar lantai, lalu berdiri.',
);
const Exercise _romanianDeadlift = Exercise(
  'Romanian Deadlift',
  reps: 10,
  cue: 'Dorong pinggul ke belakang dengan punggung datar, rasakan tarikan di paha belakang.',
);
const Exercise _bentOverRow = Exercise(
  'Bent-Over Row',
  reps: 10,
  cue: 'Condongkan badan dengan punggung datar, tarik beban ke arah pinggang.',
);
const Exercise _reverseLunge = Exercise(
  'Reverse Lunge',
  reps: 10,
  cue: 'Langkahkan satu kaki ke belakang, turunkan lutut hampir menyentuh lantai, lalu kembali berdiri.',
);
const Exercise _pushUp = Exercise(
  'Push-Up',
  reps: 10,
  cue: 'Jaga tubuh lurus dari kepala hingga tumit, turunkan dada mendekati lantai lalu dorong ke atas.',
);
const Exercise _shoulderPress = Exercise(
  'Dumbbell Shoulder Press',
  reps: 10,
  cue: 'Dorong dumbel dari bahu hingga lengan lurus di atas kepala tanpa melengkungkan punggung.',
);
const Exercise _deadBug = Exercise(
  'Dead Bug',
  reps: 10,
  cue: 'Berbaring telentang, turunkan lengan dan kaki yang berlawanan secara bergantian dengan perut tetap kencang.',
);
const Exercise _gluteBridge = Exercise(
  'Glute Bridge',
  reps: 15,
  cue: 'Berbaring dengan lutut ditekuk, angkat pinggul hingga tubuh membentuk garis lurus lalu turunkan perlahan.',
);
const Exercise _burpee = Exercise(
  'Burpee',
  reps: 8,
  cue: 'Turun ke posisi push-up, kembali berdiri, lalu lompat dengan tangan ke atas.',
);
const Exercise _squatJump = Exercise(
  'Squat Jump',
  reps: 10,
  cue: 'Turun ke posisi squat lalu lompat setinggi mungkin, mendarat dengan lutut sedikit menekuk.',
);
const Exercise _sunSalutation = Exercise(
  'Sun Salutation',
  reps: 5,
  cue: 'Alirkan gerakan dari berdiri, menunduk, plank, anjing menghadap atas, lalu kembali berdiri mengikuti napas.',
);
const Exercise _singleLegStretch = Exercise(
  'Single Leg Stretch',
  reps: 10,
  cue: 'Angkat kepala dan bahu, tarik satu lutut ke dada sambil meluruskan kaki lainnya, lalu bergantian.',
);
const Exercise _rollUp = Exercise(
  'Roll Up',
  reps: 8,
  cue: 'Gulung tulang belakang naik satu ruas demi satu ruas hingga duduk, lalu turun dengan terkendali.',
);
const Exercise _sideLegLift = Exercise(
  'Side Leg Lift',
  reps: 12,
  cue: 'Berbaring miring, angkat kaki atas setinggi pinggul dengan jari kaki menghadap depan.',
);
const Exercise _barbellSquat = Exercise(
  'Barbell Back Squat',
  reps: 8,
  cue: 'Letakkan barbel di punggung atas, turunkan pinggul dengan dada tegak, lalu dorong lantai untuk berdiri.',
);
const Exercise _benchPress = Exercise(
  'Bench Press',
  reps: 8,
  cue: 'Turunkan barbel ke tengah dada dengan siku sekitar 45 derajat, lalu dorong ke atas.',
);
const Exercise _latPulldown = Exercise(
  'Lat Pulldown',
  reps: 10,
  cue:
      'Tarik batang ke arah dada atas dengan menurunkan siku ke samping tubuh.',
);
const Exercise _legPress = Exercise(
  'Leg Press',
  reps: 12,
  cue: 'Dorong platform dengan seluruh telapak kaki tanpa mengunci lutut.',
);

const Exercise _plank40 = Exercise(
  'Plank',
  seconds: 40,
  cue:
      'Tumpu pada lengan bawah, jaga tubuh lurus, kencangkan perut dan bokong.',
);
const Exercise _plank30 = Exercise(
  'Plank',
  seconds: 30,
  cue:
      'Tumpu pada lengan bawah, jaga tubuh lurus, kencangkan perut dan bokong.',
);
const Exercise _mountainClimber = Exercise(
  'Mountain Climber',
  seconds: 30,
  cue: 'Dari posisi plank tinggi, tarik lutut ke dada secara bergantian dengan cepat.',
);
const Exercise _jumpingJack = Exercise(
  'Jumping Jack',
  seconds: 30,
  cue: 'Lompat sambil membuka kaki dan mengangkat lengan, lalu kembali ke posisi awal.',
);
const Exercise _highKnees = Exercise(
  'High Knees',
  seconds: 30,
  cue: 'Berlari di tempat dengan mengangkat lutut setinggi pinggul.',
);
const Exercise _skaters = Exercise(
  'Skater Jumps',
  seconds: 30,
  cue: 'Lompat ke samping dari satu kaki ke kaki lainnya, ayunkan lengan untuk keseimbangan.',
);
const Exercise _childsPose = Exercise(
  "Child's Pose",
  seconds: 30,
  cue: 'Duduk di atas tumit, rebahkan dada ke depan, rentangkan lengan, dan tarik napas dalam.',
);
const Exercise _downwardDog = Exercise(
  'Downward Dog',
  seconds: 30,
  cue: 'Angkat pinggul ke atas membentuk huruf V terbalik, tekan tangan ke lantai.',
);
const Exercise _warrior2 = Exercise(
  'Warrior II',
  seconds: 30,
  cue: 'Buka kaki lebar, tekuk lutut depan, rentangkan lengan sejajar bahu dan tatap ke depan.',
);
const Exercise _pigeon = Exercise(
  'Pigeon Pose',
  seconds: 40,
  cue: 'Tekuk satu kaki di depan tubuh, luruskan kaki lainnya ke belakang, lalu turunkan dada perlahan.',
);
const Exercise _cobra = Exercise(
  'Cobra Pose',
  seconds: 20,
  cue: 'Berbaring tengkurap, angkat dada dengan menekan telapak tangan, bahu menjauh dari telinga.',
);
const Exercise _hundred = Exercise(
  'The Hundred',
  seconds: 30,
  cue: 'Angkat kepala dan kaki, ayunkan lengan naik-turun kecil sambil bernapas teratur.',
);
const Exercise _swimming = Exercise(
  'Swimming',
  seconds: 30,
  cue: 'Berbaring tengkurap, angkat lengan dan kaki lalu ayunkan bergantian dengan ritme stabil.',
);

// ---------------------------------------------------------------------------
// Latihan
// ---------------------------------------------------------------------------

// Tiga latihan "Mode Hibrid" (referensi: judul, meta, durasi, label Baru).
const List<Workout> dummyHybridWorkouts = <Workout>[
  Workout(
    id: 'w1',
    title: 'Latihan Hybrid Pembangun Kekuatan untuk Lomba',
    level: 'Lanjut',
    equipment: 'Peralatan Lengkap',
    focus: 'Kekuatan',
    minutes: 45,
    image: 'assets/images/barbell_deadlift.jpg',
    isNew: true,
    categories: <String>['Kekuatan', 'Siap untuk Gym', 'HIIT'],
    description: 'Kombinasi latihan kekuatan dan kondisi fisik yang dirancang untuk mempersiapkan tubuh Anda menghadapi lomba hybrid. Mulai dengan mobilitas, lanjut ke gerakan beban utama, dan tutup dengan penahanan inti serta pendinginan.',
    exercises: <Exercise>[
      _catCow,
      _quadRocker,
      _worldsGreatest,
      _gobletSquat,
      _romanianDeadlift,
      _bentOverRow,
      _reverseLunge,
      _pushUp,
      _plank40,
      _childsPose,
    ],
  ),
  Workout(
    id: 'w2',
    title: 'Inti Sirkuit Balap Hibrid 20 Menit',
    level: 'Lanjut',
    equipment: 'Peralatan Lengkap',
    focus: 'Kekuatan',
    minutes: 20,
    image: 'assets/images/hybrid_floor_workout.jpg',
    categories: <String>['Kekuatan', 'HIIT'],
    description: 'Sirkuit singkat dan padat untuk membangun daya tahan dan kekuatan inti. Gerakan berbasis waktu menjaga detak jantung Anda tetap tinggi.',
    exercises: <Exercise>[
      _jumpingJack,
      _highKnees,
      _mountainClimber,
      _burpee,
      _plank40,
      _deadBug,
    ],
  ),
  Workout(
    id: 'w3',
    title: 'Latihan Hybrid Kekuatan & Pembentukan 30 Menit',
    level: 'Lanjut',
    equipment: 'Peralatan Lengkap',
    focus: 'Kekuatan',
    minutes: 30,
    image: 'assets/images/dumbbell_squat.jpg',
    categories: <String>['Kekuatan', 'Siap untuk Gym'],
    description: 'Latihan seluruh tubuh dengan beban untuk membentuk otot sekaligus meningkatkan kekuatan. Fokus pada teknik yang rapi di setiap repetisi.',
    exercises: <Exercise>[
      _catCow,
      _gobletSquat,
      _shoulderPress,
      _bentOverRow,
      _reverseLunge,
      _gluteBridge,
      _plank40,
    ],
  ),
];

const List<Workout> _extraWorkouts = <Workout>[
  Workout(
    id: 'w4',
    title: 'HIIT Pembakar Lemak 25 Menit',
    level: 'Menengah',
    equipment: 'Tanpa Peralatan',
    focus: 'HIIT',
    minutes: 25,
    image: 'assets/images/hiit_red_training.jpg',
    categories: <String>['HIIT'],
    description: 'Interval intensitas tinggi tanpa peralatan untuk membakar kalori dan meningkatkan kebugaran jantung.',
    exercises: <Exercise>[
      _jumpingJack,
      _squatJump,
      _mountainClimber,
      _skaters,
      _burpee,
      _highKnees,
    ],
  ),
  Workout(
    id: 'w5',
    title: 'Yoga Pemulihan Seluruh Tubuh',
    level: 'Pemula',
    equipment: 'Matras',
    focus: 'Yoga',
    minutes: 30,
    image: 'assets/images/plank_pose.jpg',
    categories: <String>['Yoga'],
    description: 'Alur yoga lembut untuk melepas ketegangan otot dan membantu pemulihan setelah hari yang aktif.',
    exercises: <Exercise>[
      _catCow,
      _downwardDog,
      _warrior2,
      _pigeon,
      _cobra,
      _childsPose,
    ],
  ),
  Workout(
    id: 'w6',
    title: 'Pilates Inti dan Postur 20 Menit',
    level: 'Pemula',
    equipment: 'Matras',
    focus: 'Pilates',
    minutes: 20,
    image: 'assets/images/core_plank.jpg',
    categories: <String>['Pilates'],
    description: 'Latihan Pilates di matras untuk menguatkan otot inti dan memperbaiki postur tubuh.',
    exercises: <Exercise>[
      _hundred,
      _rollUp,
      _singleLegStretch,
      _deadBug,
      _swimming,
      _plank30,
    ],
  ),
  Workout(
    id: 'w7',
    title: 'Dasar Latihan Beban untuk Gym',
    level: 'Pemula',
    equipment: 'Peralatan Lengkap',
    focus: 'Kekuatan',
    minutes: 40,
    image: 'assets/images/metcon_barbell.jpg',
    categories: <String>['Siap untuk Gym', 'Kekuatan'],
    description: 'Pengenalan gerakan dasar dengan barbel dan mesin agar Anda percaya diri saat memulai latihan di gym.',
    exercises: <Exercise>[
      _quadRocker,
      _barbellSquat,
      _benchPress,
      _latPulldown,
      _legPress,
      _plank30,
    ],
  ),
  Workout(
    id: 'w8',
    title: 'Sirkuit HIIT Dumbel 15 Menit',
    level: 'Menengah',
    equipment: 'Dumbel',
    focus: 'HIIT',
    minutes: 15,
    image: 'assets/images/kettlebell_squat.jpg',
    categories: <String>['HIIT', 'Kekuatan'],
    description: 'Sirkuit cepat dengan dumbel yang memadukan gerakan kekuatan dan kardio dalam waktu singkat.',
    exercises: <Exercise>[
      _gobletSquat,
      _shoulderPress,
      _bentOverRow,
      _mountainClimber,
      _burpee,
      _jumpingJack,
    ],
  ),
  Workout(
    id: 'w9',
    title: 'Yoga Alur Pagi 20 Menit',
    level: 'Pemula',
    equipment: 'Matras',
    focus: 'Yoga',
    minutes: 20,
    image: 'assets/images/group_workout.jpg',
    categories: <String>['Yoga'],
    description: 'Alur yoga singkat untuk membangunkan tubuh dan menenangkan pikiran sebelum memulai hari.',
    exercises: <Exercise>[
      _catCow,
      _sunSalutation,
      _downwardDog,
      _warrior2,
      _childsPose,
    ],
  ),
  Workout(
    id: 'w10',
    title: 'Yoga Peregangan Pinggul 25 Menit',
    level: 'Menengah',
    equipment: 'Matras',
    focus: 'Yoga',
    minutes: 25,
    image: 'assets/images/running_lunge.jpg',
    categories: <String>['Yoga'],
    description: 'Rangkaian peregangan untuk melepas kekakuan di pinggul dan punggung bawah.',
    exercises: <Exercise>[
      _catCow,
      _quadRocker,
      _pigeon,
      _worldsGreatest,
      _childsPose,
    ],
  ),
  Workout(
    id: 'w11',
    title: 'Pilates Seluruh Tubuh 30 Menit',
    level: 'Menengah',
    equipment: 'Matras',
    focus: 'Pilates',
    minutes: 30,
    image: 'assets/images/strength_dumbbell_row.webp',
    categories: <String>['Pilates'],
    description: 'Latihan Pilates menyeluruh yang melatih kontrol, keseimbangan, dan kekuatan inti.',
    exercises: <Exercise>[
      _hundred,
      _rollUp,
      _singleLegStretch,
      _sideLegLift,
      _swimming,
      _plank30,
    ],
  ),
  Workout(
    id: 'w12',
    title: 'Pilates Kaki dan Bokong 20 Menit',
    level: 'Pemula',
    equipment: 'Matras',
    focus: 'Pilates',
    minutes: 20,
    image: 'assets/images/group_running.jpg',
    categories: <String>['Pilates'],
    description: 'Fokus pada penguatan kaki dan bokong dengan gerakan terkendali yang ramah sendi.',
    exercises: <Exercise>[
      _gluteBridge,
      _sideLegLift,
      _quadRocker,
      _reverseLunge,
      _childsPose,
    ],
  ),
];

final List<Workout> dummyWorkouts = <Workout>[
  ...dummyHybridWorkouts,
  ..._extraWorkouts,
];

// Lima kategori (referensi: urutan dan nama).
const List<WorkoutCategory> dummyCategories = <WorkoutCategory>[
  WorkoutCategory(
    name: 'HIIT',
    image: 'assets/images/hiit_red_training.jpg',
    fallbackColor: Color(0xFF5E5B58),
  ),
  WorkoutCategory(
    name: 'Kekuatan',
    image: 'assets/images/barbell_deadlift.jpg',
    fallbackColor: Color(0xFF2E2E2E),
  ),
  WorkoutCategory(
    name: 'Yoga',
    image: 'assets/images/plank_pose.jpg',
    fallbackColor: Color(0xFF6E6A66),
  ),
  WorkoutCategory(
    name: 'Siap untuk Gym',
    image: 'assets/images/metcon_barbell.jpg',
    fallbackColor: Color(0xFF4B1B5A),
  ),
  WorkoutCategory(
    name: 'Pilates',
    image: 'assets/images/core_plank.jpg',
    fallbackColor: Color(0xFF4F4B4B),
  ),
];

// Program. Kartu pertama sesuai referensi; sisanya isian sementara.
const List<TrainingProgram> dummyPrograms = <TrainingProgram>[
  TrainingProgram(
    title: 'Awali Kebugaran dengan Gerakan Dasar',
    description:
        'Dasar yang Anda butuhkan untuk mendapatkan hasil yang Anda inginkan.',
    meta: '4 minggu, dumbel',
    image: 'assets/images/dumbbell_squat.jpg',
  ),
  TrainingProgram(
    title: '2 Minggu untuk Memulai Kekuatan Inti',
    description: 'Program singkat untuk membangun fondasi kekuatan inti Anda.',
    meta: '2 minggu, tanpa peralatan',
    image: 'assets/images/core_plank.jpg',
  ),
  TrainingProgram(
    title: 'Bangun Kekuatan Tubuh Bagian Atas',
    description: 'Latihan terstruktur untuk dada, punggung, dan bahu.',
    meta: '6 minggu, peralatan lengkap',
    image: 'assets/images/strength_dumbbell_row.webp',
  ),
];

// Carousel halaman Rumah. Slide pertama sesuai referensi (teks Inggris
// dipertahankan); slide 2-5 isian sementara.
const List<HeroSlide> dummyHeroSlides = <HeroSlide>[
  HeroSlide(
    label: 'Hybrid Training',
    headline: 'WORKOUTS THAT DO IT ALL',
    image: 'assets/images/hybrid_group_squat.jpg',
  ),
  HeroSlide(
    label: 'Strength',
    headline: 'BUILD STRENGTH THAT LASTS',
    image: 'assets/images/barbell_deadlift.jpg',
  ),
  HeroSlide(
    label: 'HIIT',
    headline: 'SWEAT. REPEAT. GROW.',
    image: 'assets/images/hiit_red_training.jpg',
  ),
  HeroSlide(
    label: 'Yoga',
    headline: 'MOVE WITH CALM',
    image: 'assets/images/plank_pose.jpg',
  ),
  HeroSlide(
    label: 'Pilates',
    headline: 'CORE FIRST',
    image: 'assets/images/group_running.jpg',
  ),
];

// Trofi. Tiga nama pertama sesuai referensi; sisanya isian sementara.
const List<Trophy> dummyTrophies = <Trophy>[
  Trophy(
    name: 'Hari Perempuan Internasional',
    icon: Icons.emoji_events_outlined,
    shape: TrophyShape.diamond,
  ),
  Trophy(
    name: 'Hari Tahun Baru',
    icon: Icons.celebration_outlined,
    shape: TrophyShape.diamond,
  ),
  Trophy(name: 'Yoga', icon: Icons.self_improvement),
  Trophy(name: 'Kekuatan', icon: Icons.fitness_center),
  Trophy(name: 'HIIT', icon: Icons.bolt, shape: TrophyShape.diamond),
  Trophy(name: 'Streak', icon: Icons.local_fire_department_outlined),
];

const List<String> indonesianMonths = <String>[
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];
