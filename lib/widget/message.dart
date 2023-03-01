import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//延时是为了防止在弹窗关闭时调用back,导致消息无法显示,弹窗无法关闭
showInfo(dynamic message) {
  BotToast.showCustomNotification(
      onlyOne: false,
      toastBuilder: (void Function() cancelFunc) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 100),
          decoration: BoxDecoration(
            color: const Color(0xcc3498db),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.black87, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("提示", style: TextStyle(color: Colors.black87, fontSize: 16)),
                    Text("$message", style: const TextStyle(color: Colors.black87, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

showError(dynamic message) {
  BotToast.showCustomNotification(
      onlyOne: false,
      toastBuilder: (void Function() cancelFunc) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 100),
          decoration: BoxDecoration(
            color: const Color(0xccfc624d),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel_outlined, color: Colors.black87, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("错误", style: TextStyle(color: Colors.black87, fontSize: 16)),
                    Text("$message", style: const TextStyle(color: Colors.black87, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

showWarn(dynamic message) {
  BotToast.showCustomNotification(
      onlyOne: false,
      toastBuilder: (void Function() cancelFunc) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 100),
          decoration: BoxDecoration(
            color: const Color(0xccfce38a),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_outlined, color: Colors.black87, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("警告", style: TextStyle(color: Colors.black87, fontSize: 16)),
                    Text("$message", style: const TextStyle(color: Colors.black87, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

showComplete(dynamic message) {
  BotToast.showCustomNotification(
      onlyOne: false,
      toastBuilder: (void Function() cancelFunc) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 100),
          decoration: BoxDecoration(
            color: const Color(0xcc89d961),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outlined, color: Colors.black87, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("提示", style: TextStyle(color: Colors.black87, fontSize: 16)),
                    Text("$message", style: const TextStyle(color: Colors.black87, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
