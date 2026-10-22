import 'package:dineflow/features/notification/presentation/pages/notification_screen.dart';
import 'package:dineflow/features/notification/presentation/view_models/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaiterNotificationsScreen extends StatefulWidget {
  const WaiterNotificationsScreen({super.key});

  @override
  State<WaiterNotificationsScreen> createState() =>
      _WaiterNotificationsScreenState();
}

class _WaiterNotificationsScreenState extends State<WaiterNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationCubit>().fetchNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) => const NotificationView();
}
