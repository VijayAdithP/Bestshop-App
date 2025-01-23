  class ApiEndPoints {
    static const String baseUrl = 'http://192.168.6.248:5000';
    static AuthEndPoints authEndpoints = AuthEndPoints();
  }

  class AuthEndPoints {
    final String registerEmail = '/api/auth/signup';
    final String loginEmail = '/api/auth/login';
    final String logoutEmail = '/api/auth/logout';
    final String dashboardData = '/api/stock/dashboard-data';
    final String stocksadd = '/api/stock/stock';
    final String stockview = '/api/stock/stock?date=';
    final String stockViewLocation = '/api/stock/stock?shop_location=';



    final String categories = '/api/structure/category';
    final String itemname = '/api/structure/item-name?category=';
    final String subcategory = '/api/structure/sub-category?item_name=';
    final String brand = '/api/structure/brand?sub_category=';
    final String branddrop = '/api/structure/model?brand=';
    final String modeldrop = '/api/structure/color?model=';
    final String colordrop = '/api/structure/size?color=';




    final String downloadCSV = '/api/stock/export-csv';

    //add & update inventory
    final String updateCategories = '/api/structure/category';
    final String updateItemname = '/api/structure/item_name?category=';
    final String deleteSubcategory = '/api/structuresub-category?item_name=';
    final String updateBrand = '/api/structure/brand?sub_category=';
    final String updateBranddrop = '/api/structure/model?brand=';
    final String updateModeldrop = '/api/structure/color?model=';
    final String updateColordrop = '/api/structure/size?color=';

    // edit stock
    final String stocksedit = '/api/stock/stock';

    //delete stock
    final String stocksDelete = '/api/stock/stock';

    //master apis
    final String roleFetch = "/api/master/role";
    final String getLocation = '/api/master/shop-location';

    //valuable stock
    final String valuableStock = "/api/stock/most-valuable";
  }
