// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get tagline => 'BİL . OYNA . KAZAN';

  @override
  String get welcomeBack => 'Tekrar Hoşgeldin!';

  @override
  String get usernameOrEmail => 'Kullanıcı Adı veya Email';

  @override
  String get password => 'Şifre';

  @override
  String get fieldRequired => 'Zorunlu';

  @override
  String get minSixChars => 'Min 6 karakter';

  @override
  String get loginButton => 'GİRİŞ';

  @override
  String get dontHaveAccount => 'Hesabın yok mu? ';

  @override
  String get registerLink => 'Kayıt Ol';

  @override
  String get createAccountTitle => 'Hesap Oluştur';

  @override
  String get joinBattleArena => 'GLIC savaş arenasına katıl';

  @override
  String get usernameField => 'Kullanıcı Adı';

  @override
  String get minThreeChars => 'Min 3 karakter';

  @override
  String get usernameFormatError => 'Sadece harf, rakam ve _';

  @override
  String get emailField => 'Email';

  @override
  String get invalidEmail => 'Geçersiz email';

  @override
  String get passwordWithMin => 'Şifre (min 6 karakter)';

  @override
  String get createAccountButton => 'HESAP OLUŞTUR';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı? ';

  @override
  String get loginLink => 'Giriş';

  @override
  String get daily => 'GÜNLÜK';

  @override
  String get tournament => 'TURNUVA';

  @override
  String get winBigRewards => 'Büyük ödüller kazan!';

  @override
  String get startsIn => 'Başlıyor';

  @override
  String get joinNow => 'ŞİMDİ KATIL';

  @override
  String get playModes => 'OYUN MODLARI';

  @override
  String get seeAll => 'Tümü';

  @override
  String get quickBattle => 'Hızlı Savaş';

  @override
  String get practice => 'Antrenman';

  @override
  String get battleRoyaleTitle => 'BATTLE\nROYALE';

  @override
  String get lastOneWins => 'Son Kalan Kazanır';

  @override
  String get dailyMissions => 'GÜNLÜK GÖREVLER';

  @override
  String get mission1 => '3 maç oyna';

  @override
  String get mission2 => '1 maç kazan';

  @override
  String get mission3 => '10 soruyu doğru cevapla';

  @override
  String get leaderboard => 'Sıralama';

  @override
  String get view => 'Görüntüle';

  @override
  String get topPlayers => 'En İyi Oyuncular';

  @override
  String get rankDiamond => 'Elmas';

  @override
  String get rankPlatinum => 'Platin';

  @override
  String get rankGoldII => 'Altın II';

  @override
  String get rankSilver => 'Gümüş';

  @override
  String get rankBronze => 'Bronz';

  @override
  String get levelLabel => 'Seviye';

  @override
  String get eloLabel => 'ELO';

  @override
  String get coinsLabel => 'Jeton';

  @override
  String get totalWins => 'Toplam Galibiyet';

  @override
  String get losses => 'Mağlubiyetler';

  @override
  String get totalXP => 'Toplam XP';

  @override
  String get winRate => 'Galibiyet %';

  @override
  String get achievementsTitle => 'Başarılar';

  @override
  String get achievementFirstWin => 'İlk Galibiyet';

  @override
  String get achievementTenWins => '10 Galibiyet';

  @override
  String get achievementSpeedDemon => 'Hız Canavarı';

  @override
  String get achievementFiftyWins => '50 Galibiyet';

  @override
  String get recentMatchesTitle => 'Son Maçlar';

  @override
  String get matchHistorySoon => 'Maç geçmişi yakında';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get notificationsLabel => 'Bildirimler';

  @override
  String get languageLabel => 'Dil';

  @override
  String get privacyPolicyLabel => 'Gizlilik Politikası';

  @override
  String get logoutLabel => 'Çıkış';

  @override
  String errorMessage(String message) {
    return 'Hata: $message';
  }

  @override
  String get oneVsOneBattle => '1v1 Savaş';

  @override
  String get youLabel => 'Sen';

  @override
  String get eloRankedMatch => 'ELO Dereceli Maç';

  @override
  String get findingOpponent => 'Rakip aranıyor...';

  @override
  String get matchingSimilarElo => 'Benzer ELO oyuncularıyla eşleştiriliyor';

  @override
  String get findMatchButton => 'RAKİP BUL';

  @override
  String get cancelSearch => 'İptal';

  @override
  String get coinBalanceTitle => 'Jeton Bakiyesi';

  @override
  String get xpBalanceTitle => 'XP Bakiyesi';

  @override
  String get goToShop => 'Mağazaya Git';

  @override
  String get closeAction => 'Kapat';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get noNotifications => 'Henüz bildiriminiz yok';

  @override
  String get winsLabel => 'Galibiyet';

  @override
  String get lossesLabel => 'Mağlubiyet';

  @override
  String get winRateLabel => 'G. Oranı';

  @override
  String get leaderboardTitle => 'Sıralama';

  @override
  String get youInParens => '(Sen)';

  @override
  String winsText(int count) {
    return '$count galibiyet';
  }

  @override
  String scoreLabel(int score) {
    return 'Puan: $score';
  }

  @override
  String get quizComplete => 'Test Tamamlandı!';

  @override
  String earnedLabel(int xp, int coins) {
    return '+ $xp XP   + $coins Jeton';
  }

  @override
  String get doneButton => 'Tamam';

  @override
  String get friendsTitle => 'Arkadaşlar';

  @override
  String get addButton => 'Ekle';

  @override
  String get searchPlayersHint => 'Oyuncu ara...';

  @override
  String friendsTab(int count) {
    return 'Arkadaşlar ($count)';
  }

  @override
  String requestsTab(int count) {
    return 'İstekler ($count)';
  }

  @override
  String get onlineStatus => 'Çevrimiçi';

  @override
  String get offlineStatus => 'Çevrimdışı';

  @override
  String get challengeButton => 'Meydan Oku';

  @override
  String get shopTitle => 'Mağaza';

  @override
  String get coinPacksSection => 'JETON PAKETLERİ';

  @override
  String get powerUpsSection => 'GÜÇLENDİRİCİLER';

  @override
  String get specialOffer => 'ÖZEL TEKLİF';

  @override
  String get starterBundle => 'Başlangıç Paketi';

  @override
  String get starterBundleDesc => '5000 jeton + 50 taş + 3 joker';

  @override
  String get popularBadge => 'POPÜLER';

  @override
  String get starterPack => 'Başlangıç';

  @override
  String get popularPack => 'Popüler';

  @override
  String get proPack => 'Pro';

  @override
  String get elitePack => 'Elit';

  @override
  String coinsUnit(String amount) {
    return '$amount jeton';
  }

  @override
  String get fiftyFiftyLifeline => '50/50 Joker';

  @override
  String get extraTimePowerup => 'Ekstra Süre +10s';

  @override
  String get skipQuestionPowerup => 'Soruyu Geç';

  @override
  String get tournamentsTitle => 'Turnuvalar';

  @override
  String get tournamentSubtitle => 'Şan ve ödüller için yarış';

  @override
  String get allFilter => 'Tümü';

  @override
  String get liveFilter => 'Canlı';

  @override
  String get upcomingFilter => 'Yaklaşan';

  @override
  String get myEntriesFilter => 'Kayıtlarım';

  @override
  String get dailyChampionship => 'Günlük Şampiyonluk';

  @override
  String get weekendRoyale => 'Hafta Sonu Royale';

  @override
  String get speedQuizBlitz => 'Hızlı Quiz Blitz';

  @override
  String get knowledgeMasters => 'Bilgi Ustaları';

  @override
  String playersCount(int count) {
    return '$count oyuncu';
  }

  @override
  String coinsPrize(String amount) {
    return '${amount}k jeton ödülü';
  }

  @override
  String get liveBadge => 'CANLI';

  @override
  String get joinButton => 'Katıl';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navTournaments => 'Turnuvalar';

  @override
  String get navShop => 'Mağaza';

  @override
  String get navFriends => 'Arkadaşlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get languageSelectorTitle => 'Dil Seçin';

  @override
  String get azerbaijani => 'Azərbaycan';

  @override
  String get russian => 'Русский';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get botBattle => 'Bota Karşı';

  @override
  String get botBattleSubtitle => 'AI ile yarış';

  @override
  String get soloPlay => 'Tek Oyna';

  @override
  String get soloSubtitle => 'Kendi başına antrenman yap';

  @override
  String get botLabel => 'BOT';

  @override
  String get botThinking => 'Bot düşünüyor...';

  @override
  String get botAnswered => 'Bot cevapladı ✓';

  @override
  String get youWon => 'Kazandınız! 🎉';

  @override
  String get botWon => 'Bot Kazandı 🤖';

  @override
  String get drawResult => 'Beraberlik! 🤝';

  @override
  String get yourScore => 'Puanınız';

  @override
  String get botScore => 'Bot Puanı';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get battleResult => 'Maç Sonucu';

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String coinsEarned(int coins) {
    return '+$coins Jeton';
  }
}
