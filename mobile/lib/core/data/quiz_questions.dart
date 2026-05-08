import 'dart:math';

class QuizQuestion {
  final Map<String, String> questions;
  final Map<String, List<String>> options;
  final int correct;

  const QuizQuestion({
    required this.questions,
    required this.options,
    required this.correct,
  });

  String questionFor(String locale) => questions[locale] ?? questions['en']!;
  List<String> optionsFor(String locale) => options[locale] ?? options['en']!;
}

/// 100 sualdan təsadüfi seçilmiş [count] sual qaytarır.
/// Eyni oyun sessiyasında suallar təkrarlanmır.
/// [seed] verilirsə, deterministikdir (1v1 üçün hər iki oyunçu eyni sualları görsün).
List<QuizQuestion> pickRandomQuestions(int count, {int? seed}) {
  final rng = seed != null ? Random(seed) : Random();
  final shuffled = List<QuizQuestion>.from(quizQuestions)..shuffle(rng);
  final n = count.clamp(1, quizQuestions.length);
  return shuffled.take(n).toList();
}

/// Backend-dən gələn index siyahısına görə sual qaytarır (1v1 üçün).
List<QuizQuestion> pickQuestionsByIndices(List<int> indices) {
  return indices
      .where((i) => i >= 0 && i < quizQuestions.length)
      .map((i) => quizQuestions[i])
      .toList();
}

const quizQuestions = <QuizQuestion>[
  // Q1
  QuizQuestion(
    questions: {
      'az': 'Azərbaycanın paytaxtı hansıdır?',
      'en': 'What is the capital of Azerbaijan?',
      'ru': 'Какова столица Азербайджана?',
      'tr': 'Azerbaycan\'ın başkenti nedir?',
    },
    options: {
      'az': ['Gəncə', 'Bakı', 'Sumqayıt', 'Şirvan'],
      'en': ['Ganja', 'Baku', 'Sumgait', 'Shirvan'],
      'ru': ['Гянджа', 'Баку', 'Сумгаит', 'Ширван'],
      'tr': ['Gence', 'Bakü', 'Sumgayıt', 'Şirvan'],
    },
    correct: 1,
  ),
  // Q2
  QuizQuestion(
    questions: {
      'az': 'Yer kürəsinin ən böyük okeani hansıdır?',
      'en': 'Which is the largest ocean on Earth?',
      'ru': 'Какой самый большой океан на Земле?',
      'tr': 'Dünyanın en büyük okyanusu hangisidir?',
    },
    options: {
      'az': ['Atlantik', 'Hind', 'Arktik', 'Sakit'],
      'en': ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      'ru': ['Атлантический', 'Индийский', 'Арктический', 'Тихий'],
      'tr': ['Atlantik', 'Hint', 'Arktik', 'Büyük Okyanus'],
    },
    correct: 3,
  ),
  // Q3
  QuizQuestion(
    questions: {
      'az': 'Günəş sisteminin ən böyük planeti hansıdır?',
      'en': 'Which is the largest planet in the solar system?',
      'ru': 'Самая большая планета Солнечной системы?',
      'tr': 'Güneş sisteminin en büyük gezegeni hangisidir?',
    },
    options: {
      'az': ['Saturn', 'Yupiter', 'Uran', 'Neptun'],
      'en': ['Saturn', 'Jupiter', 'Uranus', 'Neptune'],
      'ru': ['Сатурн', 'Юпитер', 'Уран', 'Нептун'],
      'tr': ['Satürn', 'Jüpiter', 'Uranüs', 'Neptün'],
    },
    correct: 1,
  ),
  // Q4
  QuizQuestion(
    questions: {
      'az': 'Suyun kimyəvi formulu nədir?',
      'en': 'What is the chemical formula of water?',
      'ru': 'Химическая формула воды?',
      'tr': 'Suyun kimyasal formülü nedir?',
    },
    options: {
      'az': ['CO₂', 'O₂', 'H₂O', 'NaCl'],
      'en': ['CO₂', 'O₂', 'H₂O', 'NaCl'],
      'ru': ['CO₂', 'O₂', 'H₂O', 'NaCl'],
      'tr': ['CO₂', 'O₂', 'H₂O', 'NaCl'],
    },
    correct: 2,
  ),
  // Q5
  QuizQuestion(
    questions: {
      'az': 'İnsan bədənindəki sümük sayı neçədir?',
      'en': 'How many bones are in the human body?',
      'ru': 'Сколько костей в теле человека?',
      'tr': 'İnsan vücudunda kaç kemik vardır?',
    },
    options: {
      'az': ['106', '206', '306', '406'],
      'en': ['106', '206', '306', '406'],
      'ru': ['106', '206', '306', '406'],
      'tr': ['106', '206', '306', '406'],
    },
    correct: 1,
  ),
  // Q6
  QuizQuestion(
    questions: {
      'az': 'Dünyanın ən hündür dağı hansıdır?',
      'en': 'Which is the tallest mountain in the world?',
      'ru': 'Какая самая высокая гора в мире?',
      'tr': 'Dünyanın en yüksek dağı hangisidir?',
    },
    options: {
      'az': ['Elbrus', 'Kilimancaro', 'Mont Blank', 'Everest'],
      'en': ['Elbrus', 'Kilimanjaro', 'Mont Blanc', 'Everest'],
      'ru': ['Эльбрус', 'Килиманджаро', 'Монблан', 'Эверест'],
      'tr': ['Elbrus', 'Kilimanjaro', 'Mont Blanc', 'Everest'],
    },
    correct: 3,
  ),
  // Q7
  QuizQuestion(
    questions: {
      'az': 'Hansı heyvan ən sürətli qaçır?',
      'en': 'Which animal runs the fastest?',
      'ru': 'Какое животное бегает быстрее всех?',
      'tr': 'Hangi hayvan en hızlı koşar?',
    },
    options: {
      'az': ['Aslan', 'Ceyran', 'Çita', 'Zəbra'],
      'en': ['Lion', 'Gazelle', 'Cheetah', 'Zebra'],
      'ru': ['Лев', 'Газель', 'Гепард', 'Зебра'],
      'tr': ['Aslan', 'Ceylan', 'Çita', 'Zebra'],
    },
    correct: 2,
  ),
  // Q8
  QuizQuestion(
    questions: {
      'az': '1 bayt neçə bitdən ibarətdir?',
      'en': 'How many bits are in one byte?',
      'ru': 'Сколько бит в одном байте?',
      'tr': 'Bir byte kaç bit\'ten oluşur?',
    },
    options: {
      'az': ['4', '16', '8', '32'],
      'en': ['4', '16', '8', '32'],
      'ru': ['4', '16', '8', '32'],
      'tr': ['4', '16', '8', '32'],
    },
    correct: 2,
  ),
  // Q9
  QuizQuestion(
    questions: {
      'az': 'Nişasta hansı qida qrupuna aiddir?',
      'en': 'Which food group does starch belong to?',
      'ru': 'К какой группе питательных веществ относится крахмал?',
      'tr': 'Nişasta hangi besin grubuna aittir?',
    },
    options: {
      'az': ['Zülal', 'Karbohidrat', 'Yağ', 'Vitamin'],
      'en': ['Protein', 'Carbohydrate', 'Fat', 'Vitamin'],
      'ru': ['Белок', 'Углевод', 'Жир', 'Витамин'],
      'tr': ['Protein', 'Karbonhidrat', 'Yağ', 'Vitamin'],
    },
    correct: 1,
  ),
  // Q10
  QuizQuestion(
    questions: {
      'az': 'Yer kürəsində neçə materik var?',
      'en': 'How many continents are there on Earth?',
      'ru': 'Сколько континентов на Земле?',
      'tr': 'Dünya\'da kaç kıta vardır?',
    },
    options: {
      'az': ['5', '6', '7', '8'],
      'en': ['5', '6', '7', '8'],
      'ru': ['5', '6', '7', '8'],
      'tr': ['5', '6', '7', '8'],
    },
    correct: 2,
  ),
  // Q11
  QuizQuestion(
    questions: {
      'az': 'Fransanın paytaxtı hansıdır?',
      'en': 'What is the capital of France?',
      'ru': 'Какова столица Франции?',
      'tr': 'Fransa\'nın başkenti nedir?',
    },
    options: {
      'az': ['London', 'Paris', 'Berlin', 'Madrid'],
      'en': ['London', 'Paris', 'Berlin', 'Madrid'],
      'ru': ['Лондон', 'Париж', 'Берлин', 'Мадрид'],
      'tr': ['Londra', 'Paris', 'Berlin', 'Madrid'],
    },
    correct: 1,
  ),
  // Q12
  QuizQuestion(
    questions: {
      'az': 'Dünyanın ən uzun çayı hansıdır?',
      'en': 'Which is the longest river in the world?',
      'ru': 'Какая самая длинная река в мире?',
      'tr': 'Dünyanın en uzun nehri hangisidir?',
    },
    options: {
      'az': ['Amazon', 'Yanszı', 'Nil', 'Missisipi'],
      'en': ['Amazon', 'Yangtze', 'Nile', 'Mississippi'],
      'ru': ['Амазонка', 'Янцзы', 'Нил', 'Миссисипи'],
      'tr': ['Amazon', 'Yangtze', 'Nil', 'Mississippi'],
    },
    correct: 2,
  ),
  // Q13
  QuizQuestion(
    questions: {
      'az': 'Göy qurşağında neçə rəng var?',
      'en': 'How many colors are in a rainbow?',
      'ru': 'Сколько цветов в радуге?',
      'tr': 'Gökkuşağında kaç renk vardır?',
    },
    options: {
      'az': ['5', '6', '7', '8'],
      'en': ['5', '6', '7', '8'],
      'ru': ['5', '6', '7', '8'],
      'tr': ['5', '6', '7', '8'],
    },
    correct: 2,
  ),
  // Q14
  QuizQuestion(
    questions: {
      'az': 'Dəniz səviyyəsində suyun qaynama temperaturu neçə °C-dir?',
      'en': 'At what temperature does water boil at sea level (°C)?',
      'ru': 'При какой температуре кипит вода на уровне моря (°C)?',
      'tr': 'Deniz seviyesinde suyun kaynama noktası kaç °C\'dir?',
    },
    options: {
      'az': ['90°C', '95°C', '100°C', '110°C'],
      'en': ['90°C', '95°C', '100°C', '110°C'],
      'ru': ['90°C', '95°C', '100°C', '110°C'],
      'tr': ['90°C', '95°C', '100°C', '110°C'],
    },
    correct: 2,
  ),
  // Q15
  QuizQuestion(
    questions: {
      'az': '"Romeo və Cülyetta" əsərinin müəllifi kimdir?',
      'en': 'Who wrote "Romeo and Juliet"?',
      'ru': 'Кто написал "Ромео и Джульетта"?',
      'tr': '"Romeo ve Juliet"i kim yazdı?',
    },
    options: {
      'az': ['Çarlz Dikkens', 'Uilyam Şekspir', 'Lev Tolstoy', 'Dante'],
      'en': ['Charles Dickens', 'William Shakespeare', 'Leo Tolstoy', 'Dante'],
      'ru': ['Чарльз Диккенс', 'Уильям Шекспир', 'Лев Толстой', 'Данте'],
      'tr': ['Charles Dickens', 'William Shakespeare', 'Lev Tolstoy', 'Dante'],
    },
    correct: 1,
  ),
  // Q16
  QuizQuestion(
    questions: {
      'az': 'İkinci Dünya Müharibəsi hansı ildə sona çatdı?',
      'en': 'In which year did World War II end?',
      'ru': 'В каком году закончилась Вторая мировая война?',
      'tr': 'İkinci Dünya Savaşı hangi yılda sona erdi?',
    },
    options: {
      'az': ['1943', '1944', '1945', '1946'],
      'en': ['1943', '1944', '1945', '1946'],
      'ru': ['1943', '1944', '1945', '1946'],
      'tr': ['1943', '1944', '1945', '1946'],
    },
    correct: 2,
  ),
  // Q17
  QuizQuestion(
    questions: {
      'az': 'Dünyanın ən kiçik ölkəsi hansıdır?',
      'en': 'What is the smallest country in the world?',
      'ru': 'Какая самая маленькая страна в мире?',
      'tr': 'Dünyanın en küçük ülkesi hangisidir?',
    },
    options: {
      'az': ['Monako', 'San-Marino', 'Vatikan', 'Lixtenşteyn'],
      'en': ['Monaco', 'San Marino', 'Vatican City', 'Liechtenstein'],
      'ru': ['Монако', 'Сан-Марино', 'Ватикан', 'Лихтенштейн'],
      'tr': ['Monako', 'San Marino', 'Vatikan', 'Lihtenştayn'],
    },
    correct: 2,
  ),
  // Q18
  QuizQuestion(
    questions: {
      'az': 'Günəş sistemindəki planet sayı neçədir?',
      'en': 'How many planets are in the solar system?',
      'ru': 'Сколько планет в Солнечной системе?',
      'tr': 'Güneş sisteminde kaç gezegen vardır?',
    },
    options: {
      'az': ['7', '8', '9', '10'],
      'en': ['7', '8', '9', '10'],
      'ru': ['7', '8', '9', '10'],
      'tr': ['7', '8', '9', '10'],
    },
    correct: 1,
  ),
  // Q19
  QuizQuestion(
    questions: {
      'az': 'Qızılın kimyəvi işarəsi nədir?',
      'en': 'What is the chemical symbol for gold?',
      'ru': 'Каков химический символ золота?',
      'tr': 'Altının kimyasal sembolü nedir?',
    },
    options: {
      'az': ['Go', 'Gd', 'Au', 'Ag'],
      'en': ['Go', 'Gd', 'Au', 'Ag'],
      'ru': ['Go', 'Gd', 'Au', 'Ag'],
      'tr': ['Go', 'Gd', 'Au', 'Ag'],
    },
    correct: 2,
  ),
  // Q20
  QuizQuestion(
    questions: {
      'az': 'Ən çox əhalisi olan ölkə hansıdır?',
      'en': 'Which country has the largest population?',
      'ru': 'Какая страна имеет наибольшее население?',
      'tr': 'En kalabalık nüfusa sahip ülke hangisidir?',
    },
    options: {
      'az': ['ABŞ', 'Hindistan', 'Çin', 'İndoneziya'],
      'en': ['USA', 'India', 'China', 'Indonesia'],
      'ru': ['США', 'Индия', 'Китай', 'Индонезия'],
      'tr': ['ABD', 'Hindistan', 'Çin', 'Endonezya'],
    },
    correct: 1,
  ),
  // Q21
  QuizQuestion(
    questions: {
      'az': '144-ün kvadrat kökü neçədir?',
      'en': 'What is the square root of 144?',
      'ru': 'Каков квадратный корень из 144?',
      'tr': '144\'ün karekökü nedir?',
    },
    options: {
      'az': ['10', '11', '12', '13'],
      'en': ['10', '11', '12', '13'],
      'ru': ['10', '11', '12', '13'],
      'tr': ['10', '11', '12', '13'],
    },
    correct: 2,
  ),
  // Q22
  QuizQuestion(
    questions: {
      'az': 'Bitkilər fotosintez zamanı hansı qazı mənimsəyir?',
      'en': 'Which gas do plants absorb during photosynthesis?',
      'ru': 'Какой газ поглощают растения при фотосинтезе?',
      'tr': 'Bitkiler fotosentez sırasında hangi gazı emer?',
    },
    options: {
      'az': ['O₂', 'N₂', 'CO₂', 'H₂'],
      'en': ['O₂', 'N₂', 'CO₂', 'H₂'],
      'ru': ['O₂', 'N₂', 'CO₂', 'H₂'],
      'tr': ['O₂', 'N₂', 'CO₂', 'H₂'],
    },
    correct: 2,
  ),
  // Q23
  QuizQuestion(
    questions: {
      'az': 'Yaponiyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Japan?',
      'ru': 'Какова столица Японии?',
      'tr': 'Japonya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Osaka', 'Kioto', 'Seul', 'Tokio'],
      'en': ['Osaka', 'Kyoto', 'Seoul', 'Tokyo'],
      'ru': ['Осака', 'Киото', 'Сеул', 'Токио'],
      'tr': ['Osaka', 'Kyoto', 'Seul', 'Tokyo'],
    },
    correct: 3,
  ),
  // Q24
  QuizQuestion(
    questions: {
      'az': 'Telefonu kim ixtira etmişdir?',
      'en': 'Who invented the telephone?',
      'ru': 'Кто изобрёл телефон?',
      'tr': 'Telefonu kim icat etti?',
    },
    options: {
      'az': ['Edison', 'Bell', 'Tesla', 'Markoni'],
      'en': ['Edison', 'Bell', 'Tesla', 'Marconi'],
      'ru': ['Эдисон', 'Белл', 'Тесла', 'Маркони'],
      'tr': ['Edison', 'Bell', 'Tesla', 'Marconi'],
    },
    correct: 1,
  ),
  // Q25
  QuizQuestion(
    questions: {
      'az': 'Ən sərt təbii maddə nədir?',
      'en': 'What is the hardest natural substance?',
      'ru': 'Какое самое твёрдое природное вещество?',
      'tr': 'En sert doğal madde nedir?',
    },
    options: {
      'az': ['Yaqut', 'Kvars', 'Almaz', 'Topaz'],
      'en': ['Ruby', 'Quartz', 'Diamond', 'Topaz'],
      'ru': ['Рубин', 'Кварц', 'Алмаз', 'Топаз'],
      'tr': ['Yakut', 'Kuvars', 'Elmas', 'Topaz'],
    },
    correct: 2,
  ),
  // Q26
  QuizQuestion(
    questions: {
      'az': 'Altıbucaqlının neçə tərəfi var?',
      'en': 'How many sides does a hexagon have?',
      'ru': 'Сколько сторон у шестиугольника?',
      'tr': 'Altıgenin kaç kenarı vardır?',
    },
    options: {
      'az': ['4', '5', '6', '8'],
      'en': ['4', '5', '6', '8'],
      'ru': ['4', '5', '6', '8'],
      'tr': ['4', '5', '6', '8'],
    },
    correct: 2,
  ),
  // Q27
  QuizQuestion(
    questions: {
      'az': 'Ən böyük məməli heyvan hansıdır?',
      'en': 'What is the largest mammal?',
      'ru': 'Какое самое большое млекопитающее?',
      'tr': 'En büyük memeli hangisidir?',
    },
    options: {
      'az': ['Fil', 'Mavi balina', 'Zürafə', 'Su atı'],
      'en': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippo'],
      'ru': ['Слон', 'Синий кит', 'Жираф', 'Бегемот'],
      'tr': ['Fil', 'Mavi balina', 'Zürafa', 'Su aygırı'],
    },
    correct: 1,
  ),
  // Q28
  QuizQuestion(
    questions: {
      'az': 'Mona Liza tablosunun müəllifi kimdir?',
      'en': 'Who painted the Mona Lisa?',
      'ru': 'Кто написал картину "Мона Лиза"?',
      'tr': 'Mona Lisa\'yı kim yaptı?',
    },
    options: {
      'az': ['Mikelancelo', 'Rafael', 'Leonardo da Vinçi', 'Pikasso'],
      'en': ['Michelangelo', 'Raphael', 'Leonardo da Vinci', 'Picasso'],
      'ru': ['Микеланджело', 'Рафаэль', 'Леонардо да Винчи', 'Пикассо'],
      'tr': ['Michelangelo', 'Raphael', 'Leonardo da Vinci', 'Picasso'],
    },
    correct: 2,
  ),
  // Q29
  QuizQuestion(
    questions: {
      'az': 'Avstraliyanın simvolu sayılan heyvan hansıdır?',
      'en': 'What is the national animal symbol of Australia?',
      'ru': 'Какое животное является символом Австралии?',
      'tr': 'Avustralya\'nın ulusal hayvan sembolü nedir?',
    },
    options: {
      'az': ['Koala', 'Ördəkburun', 'Kenguru', 'Emu'],
      'en': ['Koala', 'Platypus', 'Kangaroo', 'Emu'],
      'ru': ['Коала', 'Утконос', 'Кенгуру', 'Эму'],
      'tr': ['Koala', 'Ornitorenk', 'Kanguru', 'Emu'],
    },
    correct: 2,
  ),
  // Q30
  QuizQuestion(
    questions: {
      'az': 'Böyük Britaniyanın valyutası hansıdır?',
      'en': 'What is the currency of the United Kingdom?',
      'ru': 'Какова валюта Великобритании?',
      'tr': 'Birleşik Krallık\'ın para birimi nedir?',
    },
    options: {
      'az': ['Avro', 'Frank', 'Funt', 'Dollar'],
      'en': ['Euro', 'Franc', 'Pound', 'Dollar'],
      'ru': ['Евро', 'Франк', 'Фунт', 'Доллар'],
      'tr': ['Euro', 'Frank', 'Pound', 'Dolar'],
    },
    correct: 2,
  ),
  // Q31
  QuizQuestion(
    questions: {
      'az': 'Misir hansı materikdə yerləşir?',
      'en': 'In which continent is Egypt located?',
      'ru': 'На каком континенте находится Египет?',
      'tr': 'Mısır hangi kıtada yer almaktadır?',
    },
    options: {
      'az': ['Asiya', 'Avstraliya', 'Afrika', 'Avropa'],
      'en': ['Asia', 'Australia', 'Africa', 'Europe'],
      'ru': ['Азия', 'Австралия', 'Африка', 'Европа'],
      'tr': ['Asya', 'Avustralya', 'Afrika', 'Avrupa'],
    },
    correct: 2,
  ),
  // Q32
  QuizQuestion(
    questions: {
      'az': '2-nin 10-cu dərəcəsi neçədir?',
      'en': 'What is 2 to the power of 10?',
      'ru': 'Чему равно 2 в степени 10?',
      'tr': '2 üzeri 10 kaçtır?',
    },
    options: {
      'az': ['512', '1024', '2048', '256'],
      'en': ['512', '1024', '2048', '256'],
      'ru': ['512', '1024', '2048', '256'],
      'tr': ['512', '1024', '2048', '256'],
    },
    correct: 1,
  ),
  // Q33
  QuizQuestion(
    questions: {
      'az': 'Dəmirin kimyəvi işarəsi nədir?',
      'en': 'What is the chemical symbol for iron?',
      'ru': 'Каков химический символ железа?',
      'tr': 'Demirin kimyasal sembolü nedir?',
    },
    options: {
      'az': ['Ir', 'In', 'Fi', 'Fe'],
      'en': ['Ir', 'In', 'Fi', 'Fe'],
      'ru': ['Ir', 'In', 'Fi', 'Fe'],
      'tr': ['Ir', 'In', 'Fi', 'Fe'],
    },
    correct: 3,
  ),
  // Q34
  QuizQuestion(
    questions: {
      'az': 'Günəşə ən yaxın planet hansıdır?',
      'en': 'Which planet is closest to the Sun?',
      'ru': 'Какая планета ближайшая к Солнцу?',
      'tr': 'Güneşe en yakın gezegen hangisidir?',
    },
    options: {
      'az': ['Venera', 'Yer', 'Mars', 'Merkuri'],
      'en': ['Venus', 'Earth', 'Mars', 'Mercury'],
      'ru': ['Венера', 'Земля', 'Марс', 'Меркурий'],
      'tr': ['Venüs', 'Dünya', 'Mars', 'Merkür'],
    },
    correct: 3,
  ),
  // Q35
  QuizQuestion(
    questions: {
      'az': 'Standart gitaranın neçə simi var?',
      'en': 'How many strings does a standard guitar have?',
      'ru': 'Сколько струн у стандартной гитары?',
      'tr': 'Standart bir gitarda kaç tel bulunur?',
    },
    options: {
      'az': ['4', '5', '6', '7'],
      'en': ['4', '5', '6', '7'],
      'ru': ['4', '5', '6', '7'],
      'tr': ['4', '5', '6', '7'],
    },
    correct: 2,
  ),
  // Q36
  QuizQuestion(
    questions: {
      'az': 'Kanadanın paytaxtı hansıdır?',
      'en': 'What is the capital of Canada?',
      'ru': 'Какова столица Канады?',
      'tr': 'Kanada\'nın başkenti nedir?',
    },
    options: {
      'az': ['Toronto', 'Montreal', 'Ottawa', 'Vankuver'],
      'en': ['Toronto', 'Montreal', 'Ottawa', 'Vancouver'],
      'ru': ['Торонто', 'Монреаль', 'Оттава', 'Ванкувер'],
      'tr': ['Toronto', 'Montréal', 'Ottawa', 'Vancouver'],
    },
    correct: 2,
  ),
  // Q37
  QuizQuestion(
    questions: {
      'az': '"1984" romanının müəllifi kimdir?',
      'en': 'Who wrote the novel "1984"?',
      'ru': 'Кто написал роман "1984"?',
      'tr': '"1984" romanını kim yazdı?',
    },
    options: {
      'az': ['Oldos Haksley', 'Rey Bredberi', 'Corc Oruell', 'H.C. Uells'],
      'en': ['Aldous Huxley', 'Ray Bradbury', 'George Orwell', 'H.G. Wells'],
      'ru': ['Олдос Хаксли', 'Рэй Брэдбери', 'Джордж Оруэлл', 'Г. Дж. Уэллс'],
      'tr': ['Aldous Huxley', 'Ray Bradbury', 'George Orwell', 'H.G. Wells'],
    },
    correct: 2,
  ),
  // Q38
  QuizQuestion(
    questions: {
      'az': 'Ərazisinin böyüklüyünə görə ən böyük ölkə hansıdır?',
      'en': 'Which is the largest country in the world by area?',
      'ru': 'Какая страна самая большая по площади?',
      'tr': 'Yüzölçümüne göre dünyanın en büyük ülkesi hangisidir?',
    },
    options: {
      'az': ['ABŞ', 'Kanada', 'Çin', 'Rusiya'],
      'en': ['USA', 'Canada', 'China', 'Russia'],
      'ru': ['США', 'Канада', 'Китай', 'Россия'],
      'tr': ['ABD', 'Kanada', 'Çin', 'Rusya'],
    },
    correct: 3,
  ),
  // Q39
  QuizQuestion(
    questions: {
      'az': 'Atom nömrəsi 1 olan element hansıdır?',
      'en': 'Which element has the atomic number 1?',
      'ru': 'Какой элемент имеет атомный номер 1?',
      'tr': 'Atom numarası 1 olan element hangisidir?',
    },
    options: {
      'az': ['Helium', 'Hidrogen', 'Litium', 'Karbon'],
      'en': ['Helium', 'Hydrogen', 'Lithium', 'Carbon'],
      'ru': ['Гелий', 'Водород', 'Литий', 'Углерод'],
      'tr': ['Helyum', 'Hidrojen', 'Lityum', 'Karbon'],
    },
    correct: 1,
  ),
  // Q40
  QuizQuestion(
    questions: {
      'az': 'Ən hündür heyvan hansıdır?',
      'en': 'What is the tallest animal in the world?',
      'ru': 'Какое животное самое высокое в мире?',
      'tr': 'Dünyanın en uzun boylu hayvanı hangisidir?',
    },
    options: {
      'az': ['Fil', 'Dəvə', 'Zürafə', 'Dəvəquşu'],
      'en': ['Elephant', 'Camel', 'Giraffe', 'Ostrich'],
      'ru': ['Слон', 'Верблюд', 'Жираф', 'Страус'],
      'tr': ['Fil', 'Deve', 'Zürafa', 'Devekuşu'],
    },
    correct: 2,
  ),
  // Q41
  QuizQuestion(
    questions: {
      'az': 'İnsan ürəyinin neçə kamerası var?',
      'en': 'How many chambers does the human heart have?',
      'ru': 'Сколько камер в сердце человека?',
      'tr': 'İnsan kalbinin kaç odacığı vardır?',
    },
    options: {
      'az': ['2', '3', '4', '5'],
      'en': ['2', '3', '4', '5'],
      'ru': ['2', '3', '4', '5'],
      'tr': ['2', '3', '4', '5'],
    },
    correct: 2,
  ),
  // Q42
  QuizQuestion(
    questions: {
      'az': 'Braziliyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Brazil?',
      'ru': 'Какова столица Бразилии?',
      'tr': 'Brezilya\'nın başkenti nedir?',
    },
    options: {
      'az': ['San-Paulo', 'Rio de Janeyro', 'Braziliya', 'Salvador'],
      'en': ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'],
      'ru': ['Сан-Паулу', 'Рио-де-Жанейро', 'Бразилиа', 'Сальвадор'],
      'tr': ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'],
    },
    correct: 2,
  ),
  // Q43
  QuizQuestion(
    questions: {
      'az': 'Natriumun kimyəvi işarəsi nədir?',
      'en': 'What is the chemical symbol for sodium?',
      'ru': 'Каков химический символ натрия?',
      'tr': 'Sodyumun kimyasal sembolü nedir?',
    },
    options: {
      'az': ['So', 'Sd', 'Na', 'N'],
      'en': ['So', 'Sd', 'Na', 'N'],
      'ru': ['So', 'Sd', 'Na', 'N'],
      'tr': ['So', 'Sd', 'Na', 'N'],
    },
    correct: 2,
  ),
  // Q44
  QuizQuestion(
    questions: {
      'az': 'Wimbledon hansı idmanla əlaqədardır?',
      'en': 'Which sport is associated with Wimbledon?',
      'ru': 'С каким видом спорта связан Уимблдон?',
      'tr': 'Wimbledon hangi sporla ilişkilendirilir?',
    },
    options: {
      'az': ['Futbol', 'Kriket', 'Tennis', 'Golf'],
      'en': ['Football', 'Cricket', 'Tennis', 'Golf'],
      'ru': ['Футбол', 'Крикет', 'Теннис', 'Гольф'],
      'tr': ['Futbol', 'Kriket', 'Tenis', 'Golf'],
    },
    correct: 2,
  ),
  // Q45
  QuizQuestion(
    questions: {
      'az': 'Almaniyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Germany?',
      'ru': 'Какова столица Германии?',
      'tr': 'Almanya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Münhen', 'Hamburq', 'Köln', 'Berlin'],
      'en': ['Munich', 'Hamburg', 'Cologne', 'Berlin'],
      'ru': ['Мюнхен', 'Гамбург', 'Кёльн', 'Берлин'],
      'tr': ['Münih', 'Hamburg', 'Köln', 'Berlin'],
    },
    correct: 3,
  ),
  // Q46
  QuizQuestion(
    questions: {
      'az': 'Penisilini kim kəşf etmişdir?',
      'en': 'Who discovered penicillin?',
      'ru': 'Кто открыл пенициллин?',
      'tr': 'Penisilin\'i kim keşfetti?',
    },
    options: {
      'az': ['Paster', 'Küri', 'Fleminq', 'Lister'],
      'en': ['Pasteur', 'Curie', 'Fleming', 'Lister'],
      'ru': ['Пастер', 'Кюри', 'Флеминг', 'Листер'],
      'tr': ['Pasteur', 'Curie', 'Fleming', 'Lister'],
    },
    correct: 2,
  ),
  // Q47
  QuizQuestion(
    questions: {
      'az': 'Dünyanın ən böyük isti səhrası hansıdır?',
      'en': 'Which is the largest hot desert in the world?',
      'ru': 'Какая самая большая горячая пустыня в мире?',
      'tr': 'Dünyanın en büyük sıcak çölü hangisidir?',
    },
    options: {
      'az': ['Ərəbistan', 'Qobi', 'Saxara', 'Kalahari'],
      'en': ['Arabian', 'Gobi', 'Sahara', 'Kalahari'],
      'ru': ['Аравийская', 'Гоби', 'Сахара', 'Калахари'],
      'tr': ['Arabistan', 'Gobi', 'Sahra', 'Kalahari'],
    },
    correct: 2,
  ),
  // Q48
  QuizQuestion(
    questions: {
      'az': 'Ən çox ana dil kimi danışılan dil hansıdır?',
      'en': 'What is the most spoken language by native speakers?',
      'ru': 'Какой язык является самым распространённым как родной?',
      'tr': 'Ana dili olarak en çok konuşulan dil hangisidir?',
    },
    options: {
      'az': ['İspan', 'İngilis', 'Mandarin Çin', 'Hind'],
      'en': ['Spanish', 'English', 'Mandarin Chinese', 'Hindi'],
      'ru': ['Испанский', 'Английский', 'Мандаринский китайский', 'Хинди'],
      'tr': ['İspanyolca', 'İngilizce', 'Mandarin Çincesi', 'Hintçe'],
    },
    correct: 2,
  ),
  // Q49
  QuizQuestion(
    questions: {
      'az': 'İtaliyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Italy?',
      'ru': 'Какова столица Италии?',
      'tr': 'İtalya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Milan', 'Florensiya', 'Neapol', 'Roma'],
      'en': ['Milan', 'Florence', 'Naples', 'Rome'],
      'ru': ['Милан', 'Флоренция', 'Неаполь', 'Рим'],
      'tr': ['Milano', 'Floransa', 'Napoli', 'Roma'],
    },
    correct: 3,
  ),
  // Q50
  QuizQuestion(
    questions: {
      'az': 'Yetkin insanda neçə diş olur?',
      'en': 'How many teeth does a normal adult human have?',
      'ru': 'Сколько зубов у взрослого человека?',
      'tr': 'Normal bir yetişkin insanda kaç diş bulunur?',
    },
    options: {
      'az': ['28', '30', '32', '36'],
      'en': ['28', '30', '32', '36'],
      'ru': ['28', '30', '32', '36'],
      'tr': ['28', '30', '32', '36'],
    },
    correct: 2,
  ),
  // Q51
  QuizQuestion(
    questions: {
      'az': 'Günəş sisteminin ən kiçik planeti hansıdır?',
      'en': 'What is the smallest planet in the solar system?',
      'ru': 'Какая планета Солнечной системы самая маленькая?',
      'tr': 'Güneş sisteminin en küçük gezegeni hangisidir?',
    },
    options: {
      'az': ['Mars', 'Venera', 'Merkuri', 'Pluton'],
      'en': ['Mars', 'Venus', 'Mercury', 'Pluto'],
      'ru': ['Марс', 'Венера', 'Меркурий', 'Плутон'],
      'tr': ['Mars', 'Venüs', 'Merkür', 'Plüton'],
    },
    correct: 2,
  ),
  // Q52
  QuizQuestion(
    questions: {
      'az': 'Elektrik lampasını kim ixtira etmişdir?',
      'en': 'Who invented the electric lightbulb?',
      'ru': 'Кто изобрёл электрическую лампочку?',
      'tr': 'Elektrik ampulünü kim icat etti?',
    },
    options: {
      'az': ['Bell', 'Franklin', 'Tesla', 'Edison'],
      'en': ['Bell', 'Franklin', 'Tesla', 'Edison'],
      'ru': ['Белл', 'Франклин', 'Тесла', 'Эдисон'],
      'tr': ['Bell', 'Franklin', 'Tesla', 'Edison'],
    },
    correct: 3,
  ),
  // Q53
  QuizQuestion(
    questions: {
      'az': 'Avstraliyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Australia?',
      'ru': 'Какова столица Австралии?',
      'tr': 'Avustralya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Sidney', 'Melburn', 'Brisben', 'Kanberra'],
      'en': ['Sydney', 'Melbourne', 'Brisbane', 'Canberra'],
      'ru': ['Сидней', 'Мельбурн', 'Брисбен', 'Канберра'],
      'tr': ['Sidney', 'Melbourne', 'Brisbane', 'Canberra'],
    },
    correct: 3,
  ),
  // Q54
  QuizQuestion(
    questions: {
      'az': 'Universal qan donoru qanı hansı qrupdur?',
      'en': 'Which blood type is the universal donor?',
      'ru': 'Какая группа крови является универсальным донором?',
      'tr': 'Hangi kan grubu evrensel donördür?',
    },
    options: {
      'az': ['A+', 'B+', 'AB+', 'O-'],
      'en': ['A+', 'B+', 'AB+', 'O-'],
      'ru': ['A+', 'B+', 'AB+', 'O-'],
      'tr': ['A+', 'B+', 'AB+', 'O-'],
    },
    correct: 3,
  ),
  // Q55
  QuizQuestion(
    questions: {
      'az': 'Bir gündə neçə dəqiqə var?',
      'en': 'How many minutes are there in a day?',
      'ru': 'Сколько минут в сутках?',
      'tr': 'Bir günde kaç dakika vardır?',
    },
    options: {
      'az': ['1140', '1340', '1440', '1540'],
      'en': ['1140', '1340', '1440', '1540'],
      'ru': ['1140', '1340', '1440', '1540'],
      'tr': ['1140', '1340', '1440', '1540'],
    },
    correct: 2,
  ),
  // Q56
  QuizQuestion(
    questions: {
      'az': 'Çinin paytaxtı hansıdır?',
      'en': 'What is the capital of China?',
      'ru': 'Какова столица Китая?',
      'tr': 'Çin\'in başkenti nedir?',
    },
    options: {
      'az': ['Şanxay', 'Qancu', 'Şençjen', 'Pekin'],
      'en': ['Shanghai', 'Guangzhou', 'Shenzhen', 'Beijing'],
      'ru': ['Шанхай', 'Гуанчжоу', 'Шэньчжэнь', 'Пекин'],
      'tr': ['Şangay', 'Guangzhou', 'Shenzhen', 'Pekin'],
    },
    correct: 3,
  ),
  // Q57
  QuizQuestion(
    questions: {
      'az': 'Yer kürəsinin səthinın neçə faizi su ilə örtülüdür?',
      'en': 'What percentage of Earth\'s surface is covered by water?',
      'ru': 'Какой процент поверхности Земли покрыт водой?',
      'tr': 'Dünya yüzeyinin yüzde kaçı su ile kaplıdır?',
    },
    options: {
      'az': ['51%', '61%', '71%', '81%'],
      'en': ['51%', '61%', '71%', '81%'],
      'ru': ['51%', '61%', '71%', '81%'],
      'tr': ['51%', '61%', '71%', '81%'],
    },
    correct: 2,
  ),
  // Q58
  QuizQuestion(
    questions: {
      'az': 'Rusiyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Russia?',
      'ru': 'Какова столица России?',
      'tr': 'Rusya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Sankt-Peterburq', 'Novosibirsk', 'Moskva', 'Kazan'],
      'en': ['Saint Petersburg', 'Novosibirsk', 'Moscow', 'Kazan'],
      'ru': ['Санкт-Петербург', 'Новосибирск', 'Москва', 'Казань'],
      'tr': ['Saint Petersburg', 'Novosibirsk', 'Moskova', 'Kazan'],
    },
    correct: 2,
  ),
  // Q59
  QuizQuestion(
    questions: {
      'az': 'Titanik hansı ildə batmışdır?',
      'en': 'In which year did the Titanic sink?',
      'ru': 'В каком году затонул Титаник?',
      'tr': 'Titanik hangi yılda battı?',
    },
    options: {
      'az': ['1910', '1912', '1914', '1916'],
      'en': ['1910', '1912', '1914', '1916'],
      'ru': ['1910', '1912', '1914', '1916'],
      'tr': ['1910', '1912', '1914', '1916'],
    },
    correct: 1,
  ),
  // Q60
  QuizQuestion(
    questions: {
      'az': 'İnsan bədəninin ən böyük orqanı hansıdır?',
      'en': 'What is the largest organ of the human body?',
      'ru': 'Какой самый большой орган человеческого тела?',
      'tr': 'İnsan vücudunun en büyük organı hangisidir?',
    },
    options: {
      'az': ['Qaraciyər', 'Ürək', 'Ağciyər', 'Dəri'],
      'en': ['Liver', 'Heart', 'Lungs', 'Skin'],
      'ru': ['Печень', 'Сердце', 'Лёгкие', 'Кожа'],
      'tr': ['Karaciğer', 'Kalp', 'Akciğerler', 'Deri'],
    },
    correct: 3,
  ),
  // Q61
  QuizQuestion(
    questions: {
      'az': 'Avtomobilin ixtiraçısı kim sayılır?',
      'en': 'Who is credited with inventing the automobile?',
      'ru': 'Кто считается изобретателем автомобиля?',
      'tr': 'Otomobilin mucidi kimdir?',
    },
    options: {
      'az': ['Ford', 'Bens', 'Edison', 'Tesla'],
      'en': ['Ford', 'Benz', 'Edison', 'Tesla'],
      'ru': ['Форд', 'Бенц', 'Эдисон', 'Тесла'],
      'tr': ['Ford', 'Benz', 'Edison', 'Tesla'],
    },
    correct: 1,
  ),
  // Q62
  QuizQuestion(
    questions: {
      'az': 'İspaniyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Spain?',
      'ru': 'Какова столица Испании?',
      'tr': 'İspanya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Barselona', 'Valensiya', 'Sevilya', 'Madrid'],
      'en': ['Barcelona', 'Valencia', 'Seville', 'Madrid'],
      'ru': ['Барселона', 'Валенсия', 'Севилья', 'Мадрид'],
      'tr': ['Barselona', 'Valensiya', 'Sevilla', 'Madrid'],
    },
    correct: 3,
  ),
  // Q63
  QuizQuestion(
    questions: {
      'az': 'Ən dərin okean hansıdır?',
      'en': 'Which is the deepest ocean?',
      'ru': 'Какой океан является самым глубоким?',
      'tr': 'En derin okyanus hangisidir?',
    },
    options: {
      'az': ['Atlantik', 'Hind', 'Arktik', 'Sakit'],
      'en': ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      'ru': ['Атлантический', 'Индийский', 'Арктический', 'Тихий'],
      'tr': ['Atlantik', 'Hint', 'Arktik', 'Büyük Okyanus'],
    },
    correct: 3,
  ),
  // Q64
  QuizQuestion(
    questions: {
      'az': 'Hindistanın paytaxtı hansıdır?',
      'en': 'What is the capital of India?',
      'ru': 'Какова столица Индии?',
      'tr': 'Hindistan\'ın başkenti nedir?',
    },
    options: {
      'az': ['Mumbai', 'Çennay', 'Kəlküttə', 'Yeni Delhi'],
      'en': ['Mumbai', 'Chennai', 'Kolkata', 'New Delhi'],
      'ru': ['Мумбаи', 'Ченнаи', 'Калькутта', 'Нью-Дели'],
      'tr': ['Mumbai', 'Chennai', 'Kolkata', 'Yeni Delhi'],
    },
    correct: 3,
  ),
  // Q65
  QuizQuestion(
    questions: {
      'az': '"Böyük Qetsbi" romanının müəllifi kimdir?',
      'en': 'Who wrote "The Great Gatsby"?',
      'ru': 'Кто написал "Великий Гэтсби"?',
      'tr': '"Muhteşem Gatsby"yi kim yazdı?',
    },
    options: {
      'az': ['Heminquey', 'Staynbek', 'Fitstsjerald', 'Folkner'],
      'en': ['Hemingway', 'Steinbeck', 'Fitzgerald', 'Faulkner'],
      'ru': ['Хемингуэй', 'Стейнбек', 'Фицджеральд', 'Фолкнер'],
      'tr': ['Hemingway', 'Steinbeck', 'Fitzgerald', 'Faulkner'],
    },
    correct: 2,
  ),
  // Q66
  QuizQuestion(
    questions: {
      'az': 'Yer atmosferinin əsas qazı hansıdır?',
      'en': 'What is the main gas in Earth\'s atmosphere?',
      'ru': 'Какой основной газ в атмосфере Земли?',
      'tr': 'Dünya atmosferinin ana gazı hangisidir?',
    },
    options: {
      'az': ['Oksigen', 'Karbon dioksid', 'Arqon', 'Azot'],
      'en': ['Oxygen', 'Carbon Dioxide', 'Argon', 'Nitrogen'],
      'ru': ['Кислород', 'Углекислый газ', 'Аргон', 'Азот'],
      'tr': ['Oksijen', 'Karbondioksit', 'Argon', 'Azot'],
    },
    correct: 3,
  ),
  // Q67
  QuizQuestion(
    questions: {
      'az': 'Cənubi Koreyanın paytaxtı hansıdır?',
      'en': 'What is the capital of South Korea?',
      'ru': 'Какова столица Южной Кореи?',
      'tr': 'Güney Kore\'nin başkenti nedir?',
    },
    options: {
      'az': ['Pusan', 'İnçxon', 'Tequ', 'Seul'],
      'en': ['Busan', 'Incheon', 'Daegu', 'Seoul'],
      'ru': ['Пусан', 'Инчхон', 'Тэгу', 'Сеул'],
      'tr': ['Busan', 'Incheon', 'Daegu', 'Seul'],
    },
    correct: 3,
  ),
  // Q68
  QuizQuestion(
    questions: {
      'az': 'Eyfel qülləsi hansı şəhərdədir?',
      'en': 'In which city is the Eiffel Tower located?',
      'ru': 'В каком городе находится Эйфелева башня?',
      'tr': 'Eyfel Kulesi hangi şehirde bulunur?',
    },
    options: {
      'az': ['London', 'Roma', 'Berlin', 'Paris'],
      'en': ['London', 'Rome', 'Berlin', 'Paris'],
      'ru': ['Лондон', 'Рим', 'Берлин', 'Париж'],
      'tr': ['Londra', 'Roma', 'Berlin', 'Paris'],
    },
    correct: 3,
  ),
  // Q69
  QuizQuestion(
    questions: {
      'az': 'Karbonun atom nömrəsi neçədir?',
      'en': 'What is the atomic number of carbon?',
      'ru': 'Каков атомный номер углерода?',
      'tr': 'Karbonun atom numarası kaçtır?',
    },
    options: {
      'az': ['4', '5', '6', '7'],
      'en': ['4', '5', '6', '7'],
      'ru': ['4', '5', '6', '7'],
      'tr': ['4', '5', '6', '7'],
    },
    correct: 2,
  ),
  // Q70
  QuizQuestion(
    questions: {
      'az': 'Hansı planet halqaları ilə ən məşhurdur?',
      'en': 'Which planet is most famous for its rings?',
      'ru': 'Какая планета наиболее известна своими кольцами?',
      'tr': 'Halkaları ile en çok bilinen gezegen hangisidir?',
    },
    options: {
      'az': ['Yupiter', 'Uran', 'Neptun', 'Saturn'],
      'en': ['Jupiter', 'Uranus', 'Neptune', 'Saturn'],
      'ru': ['Юпитер', 'Уран', 'Нептун', 'Сатурн'],
      'tr': ['Jüpiter', 'Uranüs', 'Neptün', 'Satürn'],
    },
    correct: 3,
  ),
  // Q71
  QuizQuestion(
    questions: {
      'az': 'Misirin paytaxtı hansıdır?',
      'en': 'What is the capital of Egypt?',
      'ru': 'Какова столица Египта?',
      'tr': 'Mısır\'ın başkenti nedir?',
    },
    options: {
      'az': ['İsgəndəriyyə', 'Lüksor', 'Gizə', 'Qahirə'],
      'en': ['Alexandria', 'Luxor', 'Giza', 'Cairo'],
      'ru': ['Александрия', 'Луксор', 'Гиза', 'Каир'],
      'tr': ['İskenderiye', 'Luksor', 'Giza', 'Kahire'],
    },
    correct: 3,
  ),
  // Q72
  QuizQuestion(
    questions: {
      'az': 'Ən kiçik materik hansıdır?',
      'en': 'What is the smallest continent?',
      'ru': 'Какой материк самый маленький?',
      'tr': 'En küçük kıta hangisidir?',
    },
    options: {
      'az': ['Avropa', 'Antarktida', 'Cənubi Amerika', 'Avstraliya'],
      'en': ['Europe', 'Antarctica', 'South America', 'Australia'],
      'ru': ['Европа', 'Антарктида', 'Южная Америка', 'Австралия'],
      'tr': ['Avrupa', 'Antarktika', 'Güney Amerika', 'Avustralya'],
    },
    correct: 3,
  ),
  // Q73
  QuizQuestion(
    questions: {
      'az': 'Futbol komandasında neçə oyunçu var?',
      'en': 'How many players are in a football (soccer) team?',
      'ru': 'Сколько игроков в футбольной команде?',
      'tr': 'Bir futbol takımında kaç oyuncu bulunur?',
    },
    options: {
      'az': ['9', '10', '11', '12'],
      'en': ['9', '10', '11', '12'],
      'ru': ['9', '10', '11', '12'],
      'tr': ['9', '10', '11', '12'],
    },
    correct: 2,
  ),
  // Q74
  QuizQuestion(
    questions: {
      'az': 'Türkiyənin paytaxtı hansıdır?',
      'en': 'What is the capital of Turkey?',
      'ru': 'Какова столица Турции?',
      'tr': 'Türkiye\'nin başkenti nedir?',
    },
    options: {
      'az': ['İstanbul', 'İzmir', 'Bursa', 'Ankara'],
      'en': ['Istanbul', 'Izmir', 'Bursa', 'Ankara'],
      'ru': ['Стамбул', 'Измир', 'Бурса', 'Анкара'],
      'tr': ['İstanbul', 'İzmir', 'Bursa', 'Ankara'],
    },
    correct: 3,
  ),
  // Q75
  QuizQuestion(
    questions: {
      'az': 'Təyyarəni kim ixtira etmişdir?',
      'en': 'Who invented the airplane?',
      'ru': 'Кто изобрёл самолёт?',
      'tr': 'Uçağı kim icat etti?',
    },
    options: {
      'az': ['Edison qardaşları', 'Ford qardaşları', 'Armstrong qardaşları', 'Rayt qardaşları'],
      'en': ['Edison Brothers', 'Ford Brothers', 'Armstrong Brothers', 'Wright Brothers'],
      'ru': ['Братья Эдисон', 'Братья Форд', 'Братья Армстронг', 'Братья Райт'],
      'tr': ['Edison Kardeşler', 'Ford Kardeşler', 'Armstrong Kardeşler', 'Wright Kardeşler'],
    },
    correct: 3,
  ),
  // Q76
  QuizQuestion(
    questions: {
      'az': 'Dünyanın ən böyük gölü hansıdır?',
      'en': 'What is the largest lake in the world?',
      'ru': 'Какое самое большое озеро в мире?',
      'tr': 'Dünyanın en büyük gölü hangisidir?',
    },
    options: {
      'az': ['Süperior', 'Viktoriya', 'Huron', 'Xəzər dənizi'],
      'en': ['Superior', 'Victoria', 'Huron', 'Caspian Sea'],
      'ru': ['Верхнее', 'Виктория', 'Гурон', 'Каспийское море'],
      'tr': ['Superior', 'Victoria', 'Huron', 'Hazar Denizi'],
    },
    correct: 3,
  ),
  // Q77
  QuizQuestion(
    questions: {
      'az': 'ABŞ-ın paytaxtı hansıdır?',
      'en': 'What is the capital of the United States?',
      'ru': 'Какова столица США?',
      'tr': 'Amerika Birleşik Devletleri\'nin başkenti nedir?',
    },
    options: {
      'az': ['Nyu York', 'Çikaqo', 'Los-Anceles', 'Vaşinqton'],
      'en': ['New York', 'Chicago', 'Los Angeles', 'Washington D.C.'],
      'ru': ['Нью-Йорк', 'Чикаго', 'Лос-Анджелес', 'Вашингтон'],
      'tr': ['New York', 'Chicago', 'Los Angeles', 'Washington D.C.'],
    },
    correct: 3,
  ),
  // Q78
  QuizQuestion(
    questions: {
      'az': 'Berlin divarı hansı ildə uçuruldu?',
      'en': 'In which year did the Berlin Wall fall?',
      'ru': 'В каком году пала Берлинская стена?',
      'tr': 'Berlin Duvarı hangi yılda yıkıldı?',
    },
    options: {
      'az': ['1987', '1988', '1989', '1990'],
      'en': ['1987', '1988', '1989', '1990'],
      'ru': ['1987', '1988', '1989', '1990'],
      'tr': ['1987', '1988', '1989', '1990'],
    },
    correct: 2,
  ),
  // Q79
  QuizQuestion(
    questions: {
      'az': 'Suyun donma nöqtəsi neçə dərəcə Selsiydir?',
      'en': 'What is the freezing point of water in Celsius?',
      'ru': 'Какова температура замерзания воды в градусах Цельсия?',
      'tr': 'Suyun donma noktası kaç santigrat derecedir?',
    },
    options: {
      'az': ['-5°C', '-1°C', '0°C', '1°C'],
      'en': ['-5°C', '-1°C', '0°C', '1°C'],
      'ru': ['-5°C', '-1°C', '0°C', '1°C'],
      'tr': ['-5°C', '-1°C', '0°C', '1°C'],
    },
    correct: 2,
  ),
  // Q80
  QuizQuestion(
    questions: {
      'az': '"Harri Potter" kitablarının müəllifi kimdir?',
      'en': 'Who wrote the "Harry Potter" book series?',
      'ru': 'Кто написал серию книг "Гарри Поттер"?',
      'tr': '"Harry Potter" kitap serisini kim yazdı?',
    },
    options: {
      'az': ['Tolkien', 'Lyuis', 'Roulinq', 'Qayman'],
      'en': ['Tolkien', 'Lewis', 'J.K. Rowling', 'Gaiman'],
      'ru': ['Толкин', 'Льюис', 'Дж. К. Роулинг', 'Гейман'],
      'tr': ['Tolkien', 'Lewis', 'J.K. Rowling', 'Gaiman'],
    },
    correct: 2,
  ),
  // Q81
  QuizQuestion(
    questions: {
      'az': 'Meksikanın paytaxtı hansıdır?',
      'en': 'What is the capital of Mexico?',
      'ru': 'Какова столица Мексики?',
      'tr': 'Meksika\'nın başkenti nedir?',
    },
    options: {
      'az': ['Quadalaxara', 'Monterrey', 'Puebla', 'Mexiko şəhəri'],
      'en': ['Guadalajara', 'Monterrey', 'Puebla', 'Mexico City'],
      'ru': ['Гвадалахара', 'Монтеррей', 'Пуэбла', 'Мехико'],
      'tr': ['Guadalajara', 'Monterrey', 'Puebla', 'Mexico City'],
    },
    correct: 3,
  ),
  // Q82
  QuizQuestion(
    questions: {
      'az': 'Kabis ilində neçə gün var?',
      'en': 'How many days are in a leap year?',
      'ru': 'Сколько дней в високосном году?',
      'tr': 'Artık yılda kaç gün vardır?',
    },
    options: {
      'az': ['364', '365', '366', '367'],
      'en': ['364', '365', '366', '367'],
      'ru': ['364', '365', '366', '367'],
      'tr': ['364', '365', '366', '367'],
    },
    correct: 2,
  ),
  // Q83
  QuizQuestion(
    questions: {
      'az': 'Kainatda ən çox yayılmış element hansıdır?',
      'en': 'What is the most abundant element in the universe?',
      'ru': 'Какой элемент является самым распространённым во Вселенной?',
      'tr': 'Evrende en bol bulunan element hangisidir?',
    },
    options: {
      'az': ['Helium', 'Oksigen', 'Karbon', 'Hidrogen'],
      'en': ['Helium', 'Oxygen', 'Carbon', 'Hydrogen'],
      'ru': ['Гелий', 'Кислород', 'Углерод', 'Водород'],
      'tr': ['Helyum', 'Oksijen', 'Karbon', 'Hidrojen'],
    },
    correct: 3,
  ),
  // Q84
  QuizQuestion(
    questions: {
      'az': 'Argentinanın paytaxtı hansıdır?',
      'en': 'What is the capital of Argentina?',
      'ru': 'Какова столица Аргентины?',
      'tr': 'Arjantin\'in başkenti nedir?',
    },
    options: {
      'az': ['Kordova', 'Rosario', 'Mendoza', 'Buenos-Ayres'],
      'en': ['Córdoba', 'Rosario', 'Mendoza', 'Buenos Aires'],
      'ru': ['Кордова', 'Росарио', 'Мендоса', 'Буэнос-Айрес'],
      'tr': ['Córdoba', 'Rosario', 'Mendoza', 'Buenos Aires'],
    },
    correct: 3,
  ),
  // Q85
  QuizQuestion(
    questions: {
      'az': 'Sikstina Kapellasının tavanını kim boyamışdır?',
      'en': 'Who painted the ceiling of the Sistine Chapel?',
      'ru': 'Кто расписал потолок Сикстинской капеллы?',
      'tr': 'Sistine Şapeli\'nin tavanını kim boyadı?',
    },
    options: {
      'az': ['Rafael', 'Bottiçelli', 'Mikelancelo', 'Da Vinçi'],
      'en': ['Raphael', 'Botticelli', 'Michelangelo', 'Da Vinci'],
      'ru': ['Рафаэль', 'Боттичелли', 'Микеланджело', 'Да Винчи'],
      'tr': ['Raphael', 'Botticelli', 'Michelangelo', 'Da Vinci'],
    },
    correct: 2,
  ),
  // Q86
  QuizQuestion(
    questions: {
      'az': 'Havada səsin sürəti təxminən neçə m/s-dir?',
      'en': 'What is the approximate speed of sound in air (m/s)?',
      'ru': 'Какова приблизительная скорость звука в воздухе (м/с)?',
      'tr': 'Havada sesin yaklaşık hızı kaç m/s\'dir?',
    },
    options: {
      'az': ['143', '243', '343', '443'],
      'en': ['143', '243', '343', '443'],
      'ru': ['143', '243', '343', '443'],
      'tr': ['143', '243', '343', '443'],
    },
    correct: 2,
  ),
  // Q87
  QuizQuestion(
    questions: {
      'az': 'Nigeriyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Nigeria?',
      'ru': 'Какова столица Нигерии?',
      'tr': 'Nijerya\'nın başkenti nedir?',
    },
    options: {
      'az': ['Lagos', 'Kano', 'İbadan', 'Abuca'],
      'en': ['Lagos', 'Kano', 'Ibadan', 'Abuja'],
      'ru': ['Лагос', 'Кано', 'Ибадан', 'Абуджа'],
      'tr': ['Lagos', 'Kano', 'İbadan', 'Abuja'],
    },
    correct: 3,
  ),
  // Q88
  QuizQuestion(
    questions: {
      'az': 'İlk Ay enişi hansı ildə baş verdi?',
      'en': 'In which year did the first moon landing occur?',
      'ru': 'В каком году состоялась первая высадка на Луну?',
      'tr': 'İlk ay iniş hangi yılda gerçekleşti?',
    },
    options: {
      'az': ['1965', '1967', '1969', '1971'],
      'en': ['1965', '1967', '1969', '1971'],
      'ru': ['1965', '1967', '1969', '1971'],
      'tr': ['1965', '1967', '1969', '1971'],
    },
    correct: 2,
  ),
  // Q89
  QuizQuestion(
    questions: {
      'az': 'Xörək duzunun kimyəvi formulu nədir?',
      'en': 'What is the chemical formula for table salt?',
      'ru': 'Какова химическая формула поваренной соли?',
      'tr': 'Sofra tuzunun kimyasal formülü nedir?',
    },
    options: {
      'az': ['KCl', 'CaCl₂', 'NaF', 'NaCl'],
      'en': ['KCl', 'CaCl₂', 'NaF', 'NaCl'],
      'ru': ['KCl', 'CaCl₂', 'NaF', 'NaCl'],
      'tr': ['KCl', 'CaCl₂', 'NaF', 'NaCl'],
    },
    correct: 3,
  ),
  // Q90
  QuizQuestion(
    questions: {
      'az': '"Qürur və Qərəz" romanının müəllifi kimdir?',
      'en': 'Who wrote "Pride and Prejudice"?',
      'ru': 'Кто написал роман "Гордость и предубеждение"?',
      'tr': '"Gurur ve Önyargı"yı kim yazdı?',
    },
    options: {
      'az': ['Şarlotta Bronte', 'Emili Bronte', 'Ceyn Ostin', 'Virciniya Vulf'],
      'en': ['Charlotte Brontë', 'Emily Brontë', 'Jane Austen', 'Virginia Woolf'],
      'ru': ['Шарлотта Бронте', 'Эмили Бронте', 'Джейн Остин', 'Вирджиния Вулф'],
      'tr': ['Charlotte Brontë', 'Emily Brontë', 'Jane Austen', 'Virginia Woolf'],
    },
    correct: 2,
  ),
  // Q91
  QuizQuestion(
    questions: {
      'az': 'Portuqaliyanın paytaxtı hansıdır?',
      'en': 'What is the capital of Portugal?',
      'ru': 'Какова столица Португалии?',
      'tr': 'Portekiz\'in başkenti nedir?',
    },
    options: {
      'az': ['Porto', 'Braga', 'Koimbra', 'Lissabon'],
      'en': ['Porto', 'Braga', 'Coimbra', 'Lisbon'],
      'ru': ['Порту', 'Брага', 'Коимбра', 'Лиссабон'],
      'tr': ['Porto', 'Braga', 'Coimbra', 'Lizbon'],
    },
    correct: 3,
  ),
  // Q92
  QuizQuestion(
    questions: {
      'az': 'Oksigenin atom nömrəsi neçədir?',
      'en': 'What is the atomic number of oxygen?',
      'ru': 'Каков атомный номер кислорода?',
      'tr': 'Oksijenin atom numarası kaçtır?',
    },
    options: {
      'az': ['6', '7', '8', '9'],
      'en': ['6', '7', '8', '9'],
      'ru': ['6', '7', '8', '9'],
      'tr': ['6', '7', '8', '9'],
    },
    correct: 2,
  ),
  // Q93
  QuizQuestion(
    questions: {
      'az': 'Səudiyyə Ərəbistanının paytaxtı hansıdır?',
      'en': 'What is the capital of Saudi Arabia?',
      'ru': 'Какова столица Саудовской Аравии?',
      'tr': 'Suudi Arabistan\'ın başkenti nedir?',
    },
    options: {
      'az': ['Məkkə', 'Cidə', 'Mədinə', 'Ər-Riyad'],
      'en': ['Mecca', 'Jeddah', 'Medina', 'Riyadh'],
      'ru': ['Мекка', 'Джидда', 'Медина', 'Эр-Рияд'],
      'tr': ['Mekke', 'Cidde', 'Medine', 'Riyad'],
    },
    correct: 3,
  ),
  // Q94
  QuizQuestion(
    questions: {
      'az': 'İşığın sürəti təxminən neçə km/s-dir?',
      'en': 'What is the approximate speed of light (km/s)?',
      'ru': 'Какова приблизительная скорость света (км/с)?',
      'tr': 'Işığın yaklaşık hızı kaç km/s\'dir?',
    },
    options: {
      'az': ['100 000', '200 000', '300 000', '400 000'],
      'en': ['100,000', '200,000', '300,000', '400,000'],
      'ru': ['100 000', '200 000', '300 000', '400 000'],
      'tr': ['100.000', '200.000', '300.000', '400.000'],
    },
    correct: 2,
  ),
  // Q95
  QuizQuestion(
    questions: {
      'az': 'Niderlandın paytaxtı hansıdır?',
      'en': 'What is the capital of the Netherlands?',
      'ru': 'Какова столица Нидерландов?',
      'tr': 'Hollanda\'nın başkenti nedir?',
    },
    options: {
      'az': ['Rotterdam', 'Haaqa', 'Utreçt', 'Amsterdam'],
      'en': ['Rotterdam', 'The Hague', 'Utrecht', 'Amsterdam'],
      'ru': ['Роттердам', 'Гаага', 'Утрехт', 'Амстердам'],
      'tr': ['Rotterdam', 'Lahey', 'Utrecht', 'Amsterdam'],
    },
    correct: 3,
  ),
  // Q96
  QuizQuestion(
    questions: {
      'az': 'Olimpiya bayrağında neçə rəngli halqa var?',
      'en': 'How many colored rings are on the Olympic flag?',
      'ru': 'Сколько цветных колец на олимпийском флаге?',
      'tr': 'Olimpiyat bayrağında kaç renkli halka vardır?',
    },
    options: {
      'az': ['4', '5', '6', '7'],
      'en': ['4', '5', '6', '7'],
      'ru': ['4', '5', '6', '7'],
      'tr': ['4', '5', '6', '7'],
    },
    correct: 1,
  ),
  // Q97
  QuizQuestion(
    questions: {
      'az': 'Ukraynанın paytaxtı hansıdır?',
      'en': 'What is the capital of Ukraine?',
      'ru': 'Какова столица Украины?',
      'tr': 'Ukrayna\'nın başkenti nedir?',
    },
    options: {
      'az': ['Lvov', 'Xarkov', 'Odessa', 'Kiyev'],
      'en': ['Lviv', 'Kharkiv', 'Odessa', 'Kyiv'],
      'ru': ['Львов', 'Харьков', 'Одесса', 'Киев'],
      'tr': ['Lviv', 'Harkiv', 'Odessa', 'Kyiv'],
    },
    correct: 3,
  ),
  // Q98
  QuizQuestion(
    questions: {
      'az': 'C vitamini çatışmazlığı hansı xəstəliyə səbəb olur?',
      'en': 'Vitamin C deficiency causes which disease?',
      'ru': 'Дефицит витамина C вызывает какую болезнь?',
      'tr': 'C vitamini eksikliği hangi hastalığa yol açar?',
    },
    options: {
      'az': ['Raxit', 'Skorbut', 'Beriberi', 'Pellagra'],
      'en': ['Rickets', 'Scurvy', 'Beriberi', 'Pellagra'],
      'ru': ['Рахит', 'Цинга', 'Бери-бери', 'Пеллагра'],
      'tr': ['Raşitizm', 'Skorbüt', 'Beri beri', 'Pellagra'],
    },
    correct: 1,
  ),
  // Q99
  QuizQuestion(
    questions: {
      'az': 'DNA nəyin qısaltmasıdır?',
      'en': 'What does DNA stand for?',
      'ru': 'Что означает аббревиатура ДНК?',
      'tr': 'DNA neyin kısaltmasıdır?',
    },
    options: {
      'az': ['Dezoksiribonuklein turşusu', 'Dinuklein turşusu', 'Ribonuklein turşusu', 'Dioksi amin turşusu'],
      'en': ['Deoxyribonucleic Acid', 'Dinucleic Acid', 'Ribonucleic Acid', 'Dioxyamine Acid'],
      'ru': ['Дезоксирибонуклеиновая кислота', 'Динуклеиновая кислота', 'Рибонуклеиновая кислота', 'Диоксиаминовая кислота'],
      'tr': ['Deoksiribonükleik Asit', 'Dinükleik Asit', 'Ribonükleik Asit', 'Dioksiamin Asit'],
    },
    correct: 0,
  ),
  // Q100
  QuizQuestion(
    questions: {
      'az': 'Pakistanın paytaxtı hansıdır?',
      'en': 'What is the capital of Pakistan?',
      'ru': 'Какова столица Пакистана?',
      'tr': 'Pakistan\'ın başkenti nedir?',
    },
    options: {
      'az': ['Lahor', 'Karaçi', 'Peşəvar', 'İslamabad'],
      'en': ['Lahore', 'Karachi', 'Peshawar', 'Islamabad'],
      'ru': ['Лахор', 'Карачи', 'Пешавар', 'Исламабад'],
      'tr': ['Lahor', 'Karaçi', 'Peşaver', 'İslamabad'],
    },
    correct: 3,
  ),
];
