import 'dart:typed_data';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/helpers.dart';
import 'package:fava/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageSelectionWidget extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;
  final String? buttonText;
  final String? iconPath;
  final bool allowMultiple;
  final int maxSizeInMB;

  const ImageSelectionWidget({
    super.key,
    required this.onImageSelected,
    this.buttonText = 'Add Photo',
    this.iconPath = 'assets/icons/camera.svg',
    this.allowMultiple = false,
    this.maxSizeInMB = 5,
  });

  @override
  State<ImageSelectionWidget> createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  Uint8List? _selectedImage;
  bool _isLoading = false;

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgclr,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: grayMedium,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Select Image Source',
                style: AppTextStyles.futuraDemi.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              _buildOptionTile(
                icon: Icons.photo_library_outlined,
                title: 'Gallery',
                subtitle: 'Choose from your photo library',
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 12.h),
              _buildOptionTile(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              if (_selectedImage != null) ...[
                SizedBox(height: 12.h),
                _buildOptionTile(
                  icon: Icons.delete_outline,
                  title: 'Remove Photo',
                  subtitle: 'Clear selected image',
                  onTap: () {
                    Navigator.pop(context);
                    _removeImage();
                  },
                  isDestructive: true,
                ),
              ],
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? errorclr : buttonclr;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.futuraDemi.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 12.sp,
                      color: grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: grayMedium,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Uint8List? imageBytes;
      
      if (source == ImageSource.gallery) {
        imageBytes = await ImageHelper.pickImageFromGallery();
      } else {
        imageBytes = await ImageHelper.pickImageFromCamera();
      }

      if (imageBytes != null) {
        if (!ImageHelper.isImageSizeValid(imageBytes, maxSizeInMB: widget.maxSizeInMB)) {
          _showErrorSnackBar('Image size must be less than ${widget.maxSizeInMB}MB');
          return;
        }

        setState(() {
          _selectedImage = imageBytes;
        });
        widget.onImageSelected(imageBytes);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected(null);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorclr,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedImage != null) {
      return Stack(
        children: [
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: MemoryImage(_selectedImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Row(
              children: [
                _buildImageActionButton(
                  icon: Icons.edit,
                  onTap: _showImageSourceDialog,
                ),
                SizedBox(width: 8.w),
                _buildImageActionButton(
                  icon: Icons.close,
                  onTap: _removeImage,
                  isDestructive: true,
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: bgclr,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return GestureDetector(
      onTap: _isLoading ? null : _showImageSourceDialog,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          border: Border.all(color: successclr, width: 1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: successclr,
                ),
              )
            else ...[
              SvgPicture.asset(
                widget.iconPath!,
                width: 19.w,
                height: 16.h,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.buttonText!,
                style: AppTextStyles.futuraBook400.copyWith(
                  color: grayMedium,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isDestructive ? errorclr : buttonclr,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(
          icon,
          color: bgclr,
          size: 16.sp,
        ),
      ),
    );
  }
}

enum ImageSource {
  gallery,
  camera,
}