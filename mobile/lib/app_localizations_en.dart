// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tagline => 'KNOW . PLAY . WIN';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get usernameOrEmail => 'Username or Email';

  @override
  String get password => 'Password';

  @override
  String get fieldRequired => 'Required';

  @override
  String get minSixChars => 'Min 6 characters';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get registerLink => 'Register';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get joinBattleArena => 'Join the Gguiz Battle arena';

  @override
  String get usernameField => 'Username';

  @override
  String get minThreeChars => 'Min 3 characters';

  @override
  String get usernameFormatError => 'Letters, numbers and _ only';

  @override
  String get emailField => 'Email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordWithMin => 'Password (min 6 characters)';

  @override
  String get createAccountButton => 'CREATE ACCOUNT';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLink => 'Login';

  @override
  String get daily => 'DAILY';

  @override
  String get tournament => 'TOURNAMENT';

  @override
  String get winBigRewards => 'Win big rewards!';

  @override
  String get startsIn => 'Starts in';

  @override
  String get joinNow => 'JOIN NOW';

  @override
  String get playModes => 'PLAY MODES';

  @override
  String get seeAll => 'See All';

  @override
  String get quickBattle => 'Quick Battle';

  @override
  String get practice => 'Practice';

  @override
  String get battleRoyaleTitle => 'BATTLE\nROYALE';

  @override
  String get lastOneWins => 'Last One Wins';

  @override
  String get dailyMissions => 'DAILY MISSIONS';

  @override
  String get mission1 => 'Play 3 matches';

  @override
  String get mission2 => 'Win 1 match';

  @override
  String get mission3 => 'Answer 10 questions correctly';

  @override
  String missionPlayMatch(int count) {
    return 'Play $count matches';
  }

  @override
  String missionWinMatch(int count) {
    return 'Win $count matches';
  }

  @override
  String missionAnswerCorrect(int count) {
    return 'Answer $count questions correctly';
  }

  @override
  String missionFastAnswer(int count) {
    return 'Answer $count questions within 5 seconds';
  }

  @override
  String missionWinStreak(int count) {
    return 'Win $count matches in a row';
  }

  @override
  String missionRefreshIn(String time) {
    return 'Refreshes in: $time';
  }

  @override
  String get missionClaim => 'Claim';

  @override
  String get missionClaimed => 'Claimed';

  @override
  String missionRewardXp(int xp) {
    return '+$xp XP';
  }

  @override
  String missionRewardCoins(int coins) {
    return '+$coins coins';
  }

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get view => 'View';

  @override
  String get topPlayers => 'Top Players';

  @override
  String get rankDiamond => 'Diamond';

  @override
  String get rankPlatinum => 'Platinum';

  @override
  String get rankGoldII => 'Gold II';

  @override
  String get rankSilver => 'Silver';

  @override
  String get rankBronze => 'Bronze';

  @override
  String get levelLabel => 'Level';

  @override
  String get eloLabel => 'ELO';

  @override
  String get coinsLabel => 'Coins';

  @override
  String get totalWins => 'Total Wins';

  @override
  String get losses => 'Losses';

  @override
  String get totalXP => 'Total XP';

  @override
  String get winRate => 'Win Rate';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementFirstWin => 'First Win';

  @override
  String get achievementTenWins => '10 Wins';

  @override
  String get achievementSpeedDemon => 'Speed Demon';

  @override
  String get achievementFiftyWins => '50 Wins';

  @override
  String get recentMatchesTitle => 'Recent Matches';

  @override
  String get matchHistorySoon => 'Match history coming soon';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get languageLabel => 'Language';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get logoutLabel => 'Logout';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get oneVsOneBattle => '1v1 Battle';

  @override
  String get youLabel => 'You';

  @override
  String get eloRankedMatch => 'ELO Ranked Match';

  @override
  String get findingOpponent => 'Finding opponent...';

  @override
  String get matchingSimilarElo => 'Matching with similar ELO players';

  @override
  String get findMatchButton => 'FIND OPPONENT';

  @override
  String get cancelSearch => 'Cancel';

  @override
  String get noOpponentFoundYet => 'No opponent found yet';

  @override
  String get playWithBotInstead => 'Play with bot';

  @override
  String get maxLevelBadge => 'Max level';

  @override
  String get levelUpTitle => 'LEVEL UP!';

  @override
  String levelUpSubtitle(int level) {
    return 'You reached level $level!';
  }

  @override
  String get continueButton => 'CONTINUE';

  @override
  String get levelTier1 => 'BEGINNER';

  @override
  String get levelTier2 => 'EXPERIENCED';

  @override
  String get levelTier3 => 'KNOWLEDGEABLE';

  @override
  String get levelTier4 => 'MASTER';

  @override
  String get levelTier5 => 'EXPERT';

  @override
  String get levelTier6 => 'CHAMPION';

  @override
  String get levelTier7 => 'LEGENDARY';

  @override
  String get orContinueWith => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get socialLoginFailed => 'Sign-in failed. Please try again.';

  @override
  String get coinBalanceTitle => 'Coin Balance';

  @override
  String get xpBalanceTitle => 'XP Balance';

  @override
  String get goToShop => 'Go to Shop';

  @override
  String get closeAction => 'Close';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'You have no notifications yet';

  @override
  String get errorInvalidCredentials => 'Invalid username or password';

  @override
  String get errorUserExists => 'This username or email is already registered';

  @override
  String get errorNetwork =>
      'Cannot reach server. Please check your internet connection';

  @override
  String get errorGeneric => 'Something went wrong. Please try again';

  @override
  String get confirmPasswordField => 'Repeat password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get otpTitle => 'Verify your email';

  @override
  String otpSubtitle(String email) {
    return 'We sent a 6-digit code to $email';
  }

  @override
  String get otpInputHint => 'Verification code';

  @override
  String get otpVerifyButton => 'VERIFY';

  @override
  String get otpResendButton => 'Resend code';

  @override
  String get otpInvalid => 'Invalid or expired code';

  @override
  String get otpResent => 'Code sent';

  @override
  String get winsLabel => 'Wins';

  @override
  String get lossesLabel => 'Losses';

  @override
  String get winRateLabel => 'Win Rate';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get youInParens => '(You)';

  @override
  String winsText(int count) {
    return '$count wins';
  }

  @override
  String get leaderboardEmpty => 'No players yet';

  @override
  String get leaderboardEmptyHint => 'Play to be the first!';

  @override
  String get leaderboardError => 'Failed to load leaderboard';

  @override
  String scoreLabel(int score) {
    return 'Score: $score';
  }

  @override
  String get quizComplete => 'Quiz Complete!';

  @override
  String earnedLabel(int xp, int coins) {
    return '+ $xp XP   + $coins Coins';
  }

  @override
  String get doneButton => 'Done';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get addButton => 'Add';

  @override
  String get searchPlayersHint => 'Search players...';

  @override
  String friendsTab(int count) {
    return 'Friends ($count)';
  }

  @override
  String requestsTab(int count) {
    return 'Requests ($count)';
  }

  @override
  String get onlineStatus => 'Online';

  @override
  String get offlineStatus => 'Offline';

  @override
  String get challengeButton => 'Challenge';

  @override
  String get shopTitle => 'Shop';

  @override
  String get coinPacksSection => 'COIN PACKS';

  @override
  String get powerUpsSection => 'POWER-UPS';

  @override
  String get specialOffer => 'SPECIAL OFFER';

  @override
  String get starterBundle => 'Starter Bundle';

  @override
  String get starterBundleDesc => '5000 coins + 50 gems + 3 lifelines';

  @override
  String get popularBadge => 'POPULAR';

  @override
  String get starterPack => 'Starter';

  @override
  String get popularPack => 'Popular';

  @override
  String get proPack => 'Pro';

  @override
  String get elitePack => 'Elite';

  @override
  String coinsUnit(String amount) {
    return '$amount coins';
  }

  @override
  String get fiftyFiftyLifeline => '50/50 Lifeline';

  @override
  String get extraTimePowerup => 'Extra Time +10s';

  @override
  String get skipQuestionPowerup => 'Skip Question';

  @override
  String get tournamentsTitle => 'Tournaments';

  @override
  String get tournamentSubtitle => 'Compete for glory and rewards';

  @override
  String get allFilter => 'All';

  @override
  String get liveFilter => 'Live';

  @override
  String get upcomingFilter => 'Upcoming';

  @override
  String get myEntriesFilter => 'My Entries';

  @override
  String get dailyChampionship => 'Daily Championship';

  @override
  String get weekendRoyale => 'Weekend Royale';

  @override
  String get speedQuizBlitz => 'Speed Quiz Blitz';

  @override
  String get knowledgeMasters => 'Knowledge Masters';

  @override
  String playersCount(int count) {
    return '$count players';
  }

  @override
  String coinsPrize(String amount) {
    return '${amount}k coins prize';
  }

  @override
  String get liveBadge => 'LIVE';

  @override
  String get joinButton => 'Join';

  @override
  String get navHome => 'Home';

  @override
  String get navTournaments => 'Tournaments';

  @override
  String get navShop => 'Shop';

  @override
  String get navFriends => 'Friends';

  @override
  String get navProfile => 'Profile';

  @override
  String get languageSelectorTitle => 'Select Language';

  @override
  String get azerbaijani => 'Azərbaycan';

  @override
  String get russian => 'Русский';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get botBattle => 'Vs Bot';

  @override
  String get botBattleSubtitle => 'Challenge the AI';

  @override
  String get soloPlay => 'Solo Play';

  @override
  String get soloSubtitle => 'Practice on your own';

  @override
  String get botLabel => 'BOT';

  @override
  String get botThinking => 'Bot is thinking...';

  @override
  String get botAnswered => 'Bot answered ✓';

  @override
  String get youWon => 'You Won! 🎉';

  @override
  String get botWon => 'Bot Won 🤖';

  @override
  String get opponentThinking => 'is thinking...';

  @override
  String get opponentAnswered => 'answered ✓';

  @override
  String get opponentWon => 'Opponent Won';

  @override
  String get youLost => 'You Lost 💔';

  @override
  String get drawResult => 'It\'s a Draw! 🤝';

  @override
  String get yourScore => 'Your Score';

  @override
  String get botScore => 'Bot Score';

  @override
  String get playAgain => 'Play Again';

  @override
  String get battleResult => 'Match Result';

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String coinsEarned(int coins) {
    return '+$coins Coins';
  }

  @override
  String get profileLoadFailed => 'Failed to load profile';

  @override
  String get opponentDisconnectedMessage => 'Opponent disconnected';

  @override
  String get alreadyInMatchMessage => 'You are already in a match';

  @override
  String get connectionLostMessage => 'Connection lost';
}
