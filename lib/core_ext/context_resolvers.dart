import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sunny_sdk_core/services.dart';

class ProviderBuildContextResolver with SplitRegistrationResolver {
  @override
  T resolve<T>(BuildContext? context) {
    if (context == null) {
      return (throw Exception("No build context registered resolving $T"));
    }
    return Provider.of(context, listen: false);
  }

  const ProviderBuildContextResolver();

  @override
  Widget? registerAll(List<Inst> inits, {Widget? child, Key? key}) {
    final x = inits.toList();
    if (x.isNotEmpty) {
      return MultiProvider(
        key: key,
        providers: [
          for (var i in inits) i.toProvider(),
        ],
        child: child,
      );
    } else {
      return child;
    }
  }
}

mixin SplitRegistrationResolver implements BuildContextResolver {
  Widget? registerAll(List<Inst> inits, {Widget? child, Key? key});

  @override
  Widget register(resolverOrList, {Widget? child, Key? key}) {
    Iterable<Inst> extract(final input) {
      if (input is Iterable) {
        return input.expand((e) => extract(e));
      } else if (input is Inst) {
        return [input];
      } else {
        return [Inst.instance(input)];
      }
    }

    final items = extract(resolverOrList).toList();
    return registerAll(items, child: child, key: key)!;
  }
}

extension ResolverInitToProviderExt<T extends Object> on Inst<T> {
  Provider toProvider() {
    Provider<X> _toProvider<X extends Object>(Inst<X> inst) {
      return isFactory
          ? Provider<X>(
              create: (_) => inst.factory!(),
              dispose: ((_, _inst) => inst.dispose?.call(_inst)),
            )
          : Provider<X>.value(
              value: inst.instance!,
              updateShouldNotify: inst.shouldUpdate,
            );
    }

    return this.typed(_toProvider);
  }
}
