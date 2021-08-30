import 'package:sunny_fluro/sunny_fluro.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sunny_core_widgets/routes/routing.dart';
import 'package:sunny_sdk_core/model_exports.dart';
import 'package:uri/uri.dart';

import 'key_args.dart';

extension AppRouteTypedExtension<R, P extends RouteParams> on AppRoute<R, P> {
  Route<R?> toRoute(P params) {
    final AppRoute<R, P> self = this;
    final Route<R?> Function(String, P) creator =
        SunnyRouting.router.routeFactory.generate<R, P>(self, null, const Duration(milliseconds: 300), null);
    return creator(self.route, params);
  }
}

extension FRouterExtensions on FRouter {
  UriTemplateAppPageRoute<R, IdArgs<U>> userPage<U, R>(String routePath, WidgetHandler<R, IdArgs<U>> handler,
      {String? name, ToRouteTitle<IdArgs<U>>? toRouteTitle, TransitionType? transitionType}) {
    final route = UriTemplateAppPageRoute<R, IdArgs<U>>(
      UriTemplate(routePath),
      handler,
      (dyn) => IdArgs.of(dyn),
      name: name,
      toRouteTitle: toRouteTitle,
      transitionType: transitionType,
    );
    this.register(
      route,
    );
    return route;
  }

  /// Creates a [CompletableAppRoute] definition.
  CompletableAppRoute<R, IdArgs<E>> completable<R, E>(
    String routePath,
    MSchemaRef ref, {
    required CompletableHandler<R, IdArgs<E>> handler,
    String? name,
  }) {
    final completable = CompletableAppRoute<R, IdArgs<E>>(routePath, handler, (_) => IdArgs.of(_), name: name);
    this.register(completable);
    return completable;
  }

  /// Creates a [CompletableAppRoute] definition.
  CompletableAppRoute<R, P> completableWithArgs<R, P extends RouteParams>(
    String routePath, {
    required CompletableHandler<R, P> handler,
    required ParameterConverter<P> converter,
    String? name,
  }) {
    final completable = CompletableAppRoute<R, P>(routePath, handler, converter, name: name);
    this.register(completable);
    return completable;
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  UriTemplateAppPageRoute<R, IdArgs<E>> idPage<R, E>(String routePath, Widget handler(BuildContext context, IdArgs<E>? args),
      {String? name, TransitionType? transitionType}) {
    final route = UriTemplateAppPageRoute<R, IdArgs<E>>(
      UriTemplate(routePath),
      (context, args) => handler(context, args),
      (args) => IdArgs<E>.of(args),
      name: name,
      transitionType: transitionType,
    );
    this.register(route);
    return route;
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  UriTemplateCompletableAppRoute<R?, RouteParams> idModal<R>(
      String routePath, Widget handler(BuildContext context, RouteParams? args, [ScrollController? scroller]),
      {String? name, TransitionType? transitionType}) {
    final route = UriTemplateCompletableAppRoute<R?, RouteParams>(
      UriTemplate(routePath),
      ((BuildContext context, RouteParams? args, _) async {
        final R? r = await CupertinoScaffold.showCupertinoModalBottomSheet<R>(
            context: context, builder: (context) => handler(context, args));
        return r;
      }),
      defaultConverter,
      name: name,
    );
    this.register(route);
    return route;
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  UriTemplateAppPageRoute<R, P> modal<R, P extends RouteParams>(
    String routePath,
    WidgetHandler<R, P> handler, {
    ParameterConverter<P>? paramConverter,
    String? name,
    ToRouteTitle<P>? toRouteTitle,
  }) {
    return page<R, P>(
      routePath,
      handler,
      paramConverter: paramConverter,
      transitionType: TransitionType.nativeModal,
      name: name,
      toRouteTitle: toRouteTitle,
    );
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  UriTemplateAppPageRoute<R, KeyArgs> modalView<R>(
    MSchemaRef ref,
    WidgetHandler<R, KeyArgs> handler, {
    String? name,
    ToRouteTitle<KeyArgs>? toRouteTitle,
  }) {
    return page<R, KeyArgs>(
      ref.toPath("/{id}"),
      handler,
      paramConverter: ref.toConverter(),
      transitionType: TransitionType.nativeModal,
      name: name,
      toRouteTitle: toRouteTitle,
    );
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  UriTemplateAppPageRoute<R, KeyArgs> view<R>(
    MSchemaRef ref,
    WidgetHandler<R, KeyArgs> handler, {
    String? name,
    ToRouteTitle<KeyArgs>? toRouteTitle,
  }) {
    return page<R, KeyArgs>(
      ref.toPath("/{id}"),
      handler,
      paramConverter: ref.toConverter(),
      transitionType: TransitionType.native,
      name: name,
      toRouteTitle: toRouteTitle,
    );
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  UriTemplateAppPageRoute<R, RouteParams> create<R>(
    MSchemaRef ref,
    WidgetHandler<R, RouteParams> handler, {
    String? name,
    ToRouteTitle<RouteParams>? toRouteTitle,
  }) {
    return page<R, RouteParams>(
      ref.toPath("/create"),
      handler,
      paramConverter: defaultConverter,
      transitionType: TransitionType.native,
      name: name,
      toRouteTitle: toRouteTitle,
    );
  }

  UriTemplateAppPageRoute<R, RouteParams> list<R>(
    MSchemaRef ref,
    WidgetHandler<R, RouteParams> handler, {
    String? name,
    ToRouteTitle<RouteParams>? toRouteTitle,
    bool isModal = false,
  }) {
    return page<R, RouteParams>(
      ref.toPath(""),
      handler,
      paramConverter: defaultConverter,
      transitionType: isModal ? TransitionType.nativeModal : TransitionType.native,
      name: name,
      toRouteTitle: toRouteTitle,
    );
  }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
  AppRoute<R, RouteParams> function<R>(
    String routePath,
    CompletableHandler<R, RouteParams> handler, {
    String? name,
    ToRouteTitle? toRouteTitle,
  }) {
    final route = UriTemplateCompletableAppRoute<R, RouteParams>(
      UriTemplate(routePath),
      handler,
      (_) => RouteParams.of(_),
      name: name,
      toRouteTitle: toRouteTitle,
    );
    this.register(route);
    return route;
  }

// /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
// UriTemplateAppPageRoute<R, P> page<R, P extends RouteParams>(
//     String routePath, WidgetHandler<R, P> handler,
//     {ParameterConverter<P> paramConverter,
//     String title,
//     ToRouteTitle<P> toRouteTitle,
//     TransitionType transitionType}) {
//   if (P == RouteParams || P == dynamic) {
//     paramConverter ??= (args) => defaultConverter(args) as P;
//   }
//   final route = UriTemplateAppPageRoute<R, P>(
//     UriTemplate(routePath),
//     handler,
//     paramConverter,
//     name: title,
//     toRouteTitle: toRouteTitle,
//     transitionType: transitionType,
//   );
//   this.register(
//     route,
//   );
//   return route;
// }

// /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
// UriTemplateAppPageRoute<R, KeyArgs> view<R>(
//   MSchemaRef ref,
//   WidgetHandler<R, KeyArgs> handler, {
//   String title,
//   ToRouteTitle<KeyArgs> toRouteTitle,
// }) {
//   return page<R, KeyArgs>(
//     ref.toPath("/{id}"),
//     handler,
//     paramConverter: ref.toConverter(),
//     transitionType: TransitionType.native,
//     title: title,
//     toRouteTitle: toRouteTitle,
//   );
// }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
// UriTemplateAppPageRoute<EditResult, KeyArgs> edit(
//   MSchemaRef ref,
//   WidgetHandler<EditResult, KeyArgs> handler, {
//   String title,
//   ToRouteTitle<KeyArgs> toRouteTitle,
// }) {
//   return page<EditResult, KeyArgs>(
//     ref.toPath("/{id}/edit"),
//     handler,
//     paramConverter: ref.toConverter(),
//     transitionType: TransitionType.native,
//     name: title,
//     toRouteTitle: toRouteTitle,
//   );
// }

  /// Creates an [AppPageRoute] definition whose arguments are [Map<String, dynamic>]
// UriTemplateAppPageRoute<R, RouteParams> create<R>(
//   MSchemaRef ref,
//   WidgetHandler<R, RouteParams> handler, {
//   String title,
//   ToRouteTitle<RouteParams> toRouteTitle,
// }) {
//   return page<R, RouteParams>(
//     ref.toPath("/create"),
//     handler,
//     paramConverter: defaultConverter,
//     transitionType: TransitionType.native,
//     name: title,
//     toRouteTitle: toRouteTitle,
//   );
// }
}

extension MSchemaRefExt on MSchemaRef {
  ParameterConverter<KeyArgs> toConverter() {
    return (params) {
      params ??= <String, dynamic>{};
      if (params is KeyArgs) return params;
      return KeyArgs.fromArgs(this, params as Map<String, dynamic>);
    };
  }

  String toPath(String childPath) {
    return "/${artifactId!.pluralize()}${childPath}";
  }
}
