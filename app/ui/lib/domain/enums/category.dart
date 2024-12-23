
enum Category {
  all,
  electronics,
  clothing,
  shoes,
  home,
  beauty,
  sports,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.all:
        return 'All';
      case Category.electronics:
        return 'Electronics';
      case Category.clothing:
        return 'Clothes';
      case Category.home:
        return 'Home';
      case Category.beauty:
        return 'Beauty';
      case Category.sports:
        return 'Sports';
      case Category.shoes:
        return 'Shoes';
      default:
        return '';
    }
  }
}
