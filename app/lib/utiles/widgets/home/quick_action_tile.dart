import 'package:flutter/material.dart';

import '../../../features/Home/model/home_content_models.dart';
import '../neumorphic/neumorphic_container.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.action,
  });

  final HomeQuickAction action;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeumorphicContainer(
            borderRadius: 12,
            padding: const EdgeInsets.all(8),
            color: action.tint,
            child: Icon(
              action.icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const Spacer(),
          Text(
            action.label,
            style: const TextStyle(
              color: Color(0xFFECF7FF),
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            action.caption,
            style: const TextStyle(
              color: Color(0xFFA6C9EA),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
