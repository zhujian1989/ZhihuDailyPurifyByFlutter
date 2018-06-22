
class Constant {

  static const  String baseUrl="https://news-at.zhihu.com/api/4/";

  //宽高常量
  static const double bannerHeight = 200.0;
  static const double normalItemHeight = 100.0;
  static const double dateTimeItemHeight = 40.0;

  //字符串常量
  static const String todayHot = '今日热点';
  static const String themeTitle = '专题';
  static const String storyTitle = '详情';
  static const String tips = '本页应该由banner+html组成，由于Flutter对Html支持的问题，以及暂时没找到好的解决方案，暂缓该功能，怕忘记了，故保留该页面，作为优化\n请点击下面链接跳转到webview查看本文';


  //SharedPreferences key
  static const String spThemeCache = 'sp_theme_cache';
  static const String spThemeCacheHours = 'sp_theme_cache_hours';


  //time
  static const int oneDay = 24 * 60 * 60;

  //def headimg
  static const String defHeadimg = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb0V6OlKdbsP-45kue1bb3QsVF2vV6Ncm_Nw3OzSwdTmWstfzY';

  //comment pop
  static const String popReply = '回复';
  static const String popAgree = '赞同';
  static const String popCopy = '复制';
  static const String popReport = '举报';

}
