class ValuableStock {
  String? message;
  List<RankedStocks>? rankedStocks;

  ValuableStock({this.message, this.rankedStocks});

  ValuableStock.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['rankedStocks'] != null) {
      rankedStocks = <RankedStocks>[];
      json['rankedStocks'].forEach((v) {
        rankedStocks!.add(new RankedStocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.rankedStocks != null) {
      data['rankedStocks'] = this.rankedStocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RankedStocks {
  int? rank;
  int? id;
  String? name;
  int? quantity;
  int? sellingPrice;
  int? stockValue;

  RankedStocks(
      {this.rank,
      this.id,
      this.name,
      this.quantity,
      this.sellingPrice,
      this.stockValue});

  RankedStocks.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    sellingPrice = json['selling_price'];
    stockValue = json['stock_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['selling_price'] = this.sellingPrice;
    data['stock_value'] = this.stockValue;
    return data;
  }
}