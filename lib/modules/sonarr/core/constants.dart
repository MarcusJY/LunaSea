import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class SonarrConstants {
    SonarrConstants._();

    static const String MODULE_KEY = 'sonarr';

    static const LunaModuleMap MODULE_MAP = LunaModuleMap(
        name: 'Sonarr',
        description: 'Manage Television Series',
        settingsDescription: 'Configure Sonarr',
        icon: CustomIcons.television,
        route: '/sonarr',
        color: Color(0xFF3FC6F4),
    );

    //ignore: non_constant_identifier_names
    static final ShortcutItem MODULE_QUICK_ACTION = ShortcutItem(
        type: MODULE_KEY,
        localizedTitle: MODULE_MAP.name,
    );
}
