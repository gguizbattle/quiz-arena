// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tagline => 'ЗНАЙ . ИГРАЙ . ПОБЕЖДАЙ';

  @override
  String get welcomeBack => 'С возвращением!';

  @override
  String get usernameOrEmail => 'Имя пользователя или Email';

  @override
  String get password => 'Пароль';

  @override
  String get fieldRequired => 'Обязательно';

  @override
  String get minSixChars => 'Мин 6 символов';

  @override
  String get loginButton => 'ВОЙТИ';

  @override
  String get dontHaveAccount => 'Нет аккаунта? ';

  @override
  String get registerLink => 'Регистрация';

  @override
  String get createAccountTitle => 'Создать аккаунт';

  @override
  String get joinBattleArena => 'Присоединяйся к арене GLIC';

  @override
  String get usernameField => 'Имя пользователя';

  @override
  String get minThreeChars => 'Мин 3 символа';

  @override
  String get usernameFormatError => 'Только буквы, цифры и _';

  @override
  String get emailField => 'Email';

  @override
  String get invalidEmail => 'Неверный email';

  @override
  String get passwordWithMin => 'Пароль (мин 6 символов)';

  @override
  String get createAccountButton => 'СОЗДАТЬ АККАУНТ';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get loginLink => 'Войти';

  @override
  String get daily => 'ЕЖЕДНЕВНЫЙ';

  @override
  String get tournament => 'ТУРНИР';

  @override
  String get winBigRewards => 'Выигрывай большие награды!';

  @override
  String get startsIn => 'Начинается через';

  @override
  String get joinNow => 'УЧАСТВОВАТЬ';

  @override
  String get playModes => 'РЕЖИМЫ ИГРЫ';

  @override
  String get seeAll => 'Все';

  @override
  String get quickBattle => 'Быстрый бой';

  @override
  String get practice => 'Тренировка';

  @override
  String get battleRoyaleTitle => 'БАТЛ\nРОЯЛЬ';

  @override
  String get lastOneWins => 'Побеждает последний';

  @override
  String get dailyMissions => 'ЕЖЕДНЕВНЫЕ ЗАДАНИЯ';

  @override
  String get mission1 => 'Сыграй 3 матча';

  @override
  String get mission2 => 'Выиграй 1 матч';

  @override
  String get mission3 => 'Ответь правильно на 10 вопросов';

  @override
  String get leaderboard => 'Рейтинг';

  @override
  String get view => 'Смотреть';

  @override
  String get topPlayers => 'Лучшие игроки';

  @override
  String get rankDiamond => 'Алмаз';

  @override
  String get rankPlatinum => 'Платина';

  @override
  String get rankGoldII => 'Золото II';

  @override
  String get rankSilver => 'Серебро';

  @override
  String get rankBronze => 'Бронза';

  @override
  String get levelLabel => 'Уровень';

  @override
  String get eloLabel => 'ELO';

  @override
  String get coinsLabel => 'Монеты';

  @override
  String get totalWins => 'Всего побед';

  @override
  String get losses => 'Поражения';

  @override
  String get totalXP => 'Всего XP';

  @override
  String get winRate => '% побед';

  @override
  String get achievementsTitle => 'Достижения';

  @override
  String get achievementFirstWin => 'Первая победа';

  @override
  String get achievementTenWins => '10 побед';

  @override
  String get achievementSpeedDemon => 'Демон скорости';

  @override
  String get achievementFiftyWins => '50 побед';

  @override
  String get recentMatchesTitle => 'Последние матчи';

  @override
  String get matchHistorySoon => 'История матчей скоро';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get notificationsLabel => 'Уведомления';

  @override
  String get languageLabel => 'Язык';

  @override
  String get privacyPolicyLabel => 'Политика конфиденциальности';

  @override
  String get logoutLabel => 'Выйти';

  @override
  String errorMessage(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get oneVsOneBattle => 'Бой 1 на 1';

  @override
  String get youLabel => 'Вы';

  @override
  String get eloRankedMatch => 'Рейтинговый матч ELO';

  @override
  String get findingOpponent => 'Поиск соперника...';

  @override
  String get matchingSimilarElo => 'Подбираем игроков с похожим ELO';

  @override
  String get findMatchButton => 'НАЙТИ СОПЕРНИКА';

  @override
  String get cancelSearch => 'Отмена';

  @override
  String get coinBalanceTitle => 'Баланс монет';

  @override
  String get xpBalanceTitle => 'Баланс XP';

  @override
  String get goToShop => 'В магазин';

  @override
  String get closeAction => 'Закрыть';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get noNotifications => 'У вас пока нет уведомлений';

  @override
  String get winsLabel => 'Победы';

  @override
  String get lossesLabel => 'Поражения';

  @override
  String get winRateLabel => '% Побед';

  @override
  String get leaderboardTitle => 'Рейтинг';

  @override
  String get youInParens => '(Вы)';

  @override
  String winsText(int count) {
    return '$count побед';
  }

  @override
  String scoreLabel(int score) {
    return 'Счёт: $score';
  }

  @override
  String get quizComplete => 'Тест завершён!';

  @override
  String earnedLabel(int xp, int coins) {
    return '+ $xp XP   + $coins Монет';
  }

  @override
  String get doneButton => 'Готово';

  @override
  String get friendsTitle => 'Друзья';

  @override
  String get addButton => 'Добавить';

  @override
  String get searchPlayersHint => 'Поиск игроков...';

  @override
  String friendsTab(int count) {
    return 'Друзья ($count)';
  }

  @override
  String requestsTab(int count) {
    return 'Заявки ($count)';
  }

  @override
  String get onlineStatus => 'В сети';

  @override
  String get offlineStatus => 'Не в сети';

  @override
  String get challengeButton => 'Вызов';

  @override
  String get shopTitle => 'Магазин';

  @override
  String get coinPacksSection => 'ПАКЕТЫ МОНЕТ';

  @override
  String get powerUpsSection => 'УСИЛИТЕЛИ';

  @override
  String get specialOffer => 'СПЕЦПРЕДЛОЖЕНИЕ';

  @override
  String get starterBundle => 'Стартовый набор';

  @override
  String get starterBundleDesc => '5000 монет + 50 кристаллов + 3 подсказки';

  @override
  String get popularBadge => 'ПОПУЛЯРНО';

  @override
  String get starterPack => 'Стартовый';

  @override
  String get popularPack => 'Популярный';

  @override
  String get proPack => 'Про';

  @override
  String get elitePack => 'Элитный';

  @override
  String coinsUnit(String amount) {
    return '$amount монет';
  }

  @override
  String get fiftyFiftyLifeline => 'Подсказка 50/50';

  @override
  String get extraTimePowerup => 'Доп. время +10с';

  @override
  String get skipQuestionPowerup => 'Пропустить вопрос';

  @override
  String get tournamentsTitle => 'Турниры';

  @override
  String get tournamentSubtitle => 'Борись за славу и награды';

  @override
  String get allFilter => 'Все';

  @override
  String get liveFilter => 'В эфире';

  @override
  String get upcomingFilter => 'Ближайшие';

  @override
  String get myEntriesFilter => 'Мои заявки';

  @override
  String get dailyChampionship => 'Ежедневный чемпионат';

  @override
  String get weekendRoyale => 'Выходной Рояль';

  @override
  String get speedQuizBlitz => 'Быстрый блиц';

  @override
  String get knowledgeMasters => 'Мастера знаний';

  @override
  String playersCount(int count) {
    return '$count игроков';
  }

  @override
  String coinsPrize(String amount) {
    return 'Приз ${amount}k монет';
  }

  @override
  String get liveBadge => 'ПРЯМОЙ ЭФИР';

  @override
  String get joinButton => 'Участвовать';

  @override
  String get navHome => 'Главная';

  @override
  String get navTournaments => 'Турниры';

  @override
  String get navShop => 'Магазин';

  @override
  String get navFriends => 'Друзья';

  @override
  String get navProfile => 'Профиль';

  @override
  String get languageSelectorTitle => 'Выберите язык';

  @override
  String get azerbaijani => 'Azərbaycan';

  @override
  String get russian => 'Русский';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get botBattle => 'Против бота';

  @override
  String get botBattleSubtitle => 'Сыграй с ИИ';

  @override
  String get soloPlay => 'Соло режим';

  @override
  String get soloSubtitle => 'Тренировка в одиночку';

  @override
  String get botLabel => 'БОТ';

  @override
  String get botThinking => 'Бот думает...';

  @override
  String get botAnswered => 'Бот ответил ✓';

  @override
  String get youWon => 'Вы победили! 🎉';

  @override
  String get botWon => 'Бот победил 🤖';

  @override
  String get drawResult => 'Ничья! 🤝';

  @override
  String get yourScore => 'Ваш счёт';

  @override
  String get botScore => 'Счёт бота';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get battleResult => 'Результат матча';

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String coinsEarned(int coins) {
    return '+$coins Монет';
  }
}
