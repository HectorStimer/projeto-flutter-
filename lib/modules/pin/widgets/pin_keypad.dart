import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class PinKeypad extends StatelessWidget {
  final Function(String) onNumberSelected;
  final VoidCallback onDelete;

  const PinKeypad({
    super.key,
    required this.onNumberSelected,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Column(
      children: buttons.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((btn) {
            final isDelete = btn == '⌫';
            final isEmpty = btn.isEmpty;

            return GestureDetector(
              onTap: isEmpty
                  ? null
                  : isDelete
                  ? onDelete
                  : () => onNumberSelected(btn),
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEmpty ? Colors.transparent : AppColors.surface,
                  border: Border.all(
                    color: isEmpty
                        ? Colors.transparent
                        : AppColors.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: isEmpty
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEmpty
                        ? null
                        : isDelete
                        ? onDelete
                        : () => onNumberSelected(btn),
                    borderRadius: BorderRadius.circular(35),
                    child: Center(
                      child: isEmpty
                          ? const SizedBox()
                          : isDelete
                          ? Icon(
                              Icons.backspace_outlined,
                              color: AppColors.primary,
                              size: 24,
                            )
                          : Text(
                              btn,
                              style: AppTextStyles.buttonText.copyWith(
                                fontSize: 32,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
