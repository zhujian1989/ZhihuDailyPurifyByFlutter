class Apis {

  //首页数据
  static const String latest = "news/latest";

  //首页数据 跟日期 example：news/before/20131119
  static const String before ="news/before/" ;

  //详情 跟id example：news/3892357
  static const String detail = "news/";

  //评论数 点赞数 跟id example：news/3892357
  static const String story_extra = "story-extra/";

  //长评论详情 跟id example:story/8997528/long-comments
  static const String long_comment = "story/id/long-comments";

  //短评论详情 跟id
  static const String short_comment = "story/id/short-comments";

  //查看主题日报分类列表
  static const String themes = "themes";

  //查看某个主题的列表 跟id example：themes/13
  static const String themes_list = "theme/";

  //查看某个主题的列表 跟tid story_id 是每次请求的最后一条 example：theme/13/before/4731018
  static const String themes_list_before = "/before/";


}
