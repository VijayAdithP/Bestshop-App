class ApiEndPoints {
  static const String baseUrl = 'http://10.10.190.179:5000';
  static AuthEndPoints authEndpoints = AuthEndPoints();
}

class AuthEndPoints {
  final String registerEmail = '/api/auth/signup';
  final String loginEmail = '/api/auth/login';
  final String logoutEmail = '/api/auth/logout';
  final String dashboardData = '/api/stock/dashboard-data';
  final String stocksadd = '/api/stock/stock';
  final String stockview = '/api/stock/stock?date=';
  final String categories = '/api/structure/category';
  final String itemname = '/api/structure/item-name?category=';
  final String subcategory = '/api/structure/sub-category?item_name=';
  final String brand = '/api/structure/brand?sub_category=';
  final String branddrop = '/api/structure/model?brand=';
  final String modeldrop = '/api/structure/color?model=';
  final String colordrop = '/api/structure/size?color=';
}
