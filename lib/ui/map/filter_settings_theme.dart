import 'package:reservation_system_customer/ui_imports.dart';

extension FillStatusColor on FillStatus {
  Color color(context) {
    switch (this) {
      case FillStatus.green:
        return Theme.of(context).accentColor;
      case FillStatus.yellow:
        return Colors.orange;
      case FillStatus.red:
        return Colors.red;
    }
    return Theme.of(context).accentColor;
  }
}

extension LocationTypeIcon on LocationType {
  IconData icon(context) {
    switch (this) {
      case LocationType.supermarket:
        return Icons.local_grocery_store;
      case LocationType.pharmacy:
        return Icons.local_pharmacy;
      case LocationType.bakery:
        return Icons.local_cafe;
    }
    return null;
  }
}
