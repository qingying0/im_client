import 'package:provider/provider.dart';

class Store {

  static T value<T>(context) {
    return Provider.of<T>(context);
  }

  static Consumer connect<T>({builder, child}) {
    return Consumer<T>(builder: builder, child: child,);
  }
}
