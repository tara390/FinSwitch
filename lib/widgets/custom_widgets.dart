import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_constants.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? prefix;
  final String? suffix;
  final bool enabled;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Color? focusColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.maxLines = 1,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.focusColor,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFocusColor = focusColor ?? AppConstants.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            enabled: enabled,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            onTap: onTap,
            onChanged: onChanged,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixText: prefix,
              suffixText: suffix,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: effectiveFocusColor, size: 20)
                  : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixIconTap,
                      child: Icon(suffixIcon, color: Colors.grey[600], size: 20),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: effectiveFocusColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppConstants.errorColor, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppConstants.errorColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.normal,
              ),
              prefixStyle: TextStyle(
                color: effectiveFocusColor,
                fontWeight: FontWeight.w600,
              ),
              suffixStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ModernSliderInput extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
  final double sliderValue;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String minLabel;
  final String maxLabel;

  const ModernSliderInput({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    required this.sliderValue,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    required this.minLabel,
    required this.maxLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$value $unit',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.2),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              trackHeight: 4,
            ),
            child: Slider(
              value: sliderValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                maxLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditableSliderInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String unit;
  final Color color;
  final IconData icon;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String minLabel;
  final String maxLabel;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const EditableSliderInput({
    super.key,
    required this.label,
    required this.controller,
    required this.unit,
    required this.color,
    required this.icon,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    required this.minLabel,
    required this.maxLabel,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<EditableSliderInput> createState() => _EditableSliderInputState();
}

class _EditableSliderInputState extends State<EditableSliderInput> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(widget.controller.text) ?? widget.min;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: widget.color,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            Container(
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.color.withValues(alpha: 0.3), width: 1),
              ),
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.number,
                validator: widget.validator,
                inputFormatters: widget.inputFormatters,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 20,
                  ),
                  suffixText: widget.unit,
                  suffixStyle: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onChanged: (text) {
                  final newValue = double.tryParse(text);
                  if (newValue != null && newValue >= widget.min && newValue <= widget.max) {
                    widget.onChanged(newValue);
                  }
                },
                onFieldSubmitted: (_) {
                  setState(() {
                    _isEditing = false;
                  });
                },
              ),
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.color.withValues(alpha: 0.2), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.color,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.controller.text} ${widget.unit}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: widget.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: widget.color.withValues(alpha: 0.7),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.color,
              inactiveTrackColor: widget.color.withValues(alpha: 0.2),
              thumbColor: widget.color,
              overlayColor: widget.color.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              trackHeight: 4,
            ),
            child: Slider(
              value: value.clamp(widget.min, widget.max),
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              onChanged: (newValue) {
                widget.controller.text = newValue.round().toString();
                widget.onChanged(newValue);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.minLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                widget.maxLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final IconData? icon;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppConstants.primaryColor;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor.withOpacity(0.1),
              cardColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: cardColor, size: 18),
                  const SizedBox(width: AppConstants.paddingSmall),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cardColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppConstants.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(width: AppConstants.paddingSmall),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
