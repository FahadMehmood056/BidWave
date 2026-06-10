import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sb.dart';
import '../../../auctions/presentation/bloc/post_auction_bloc/post_auction_bloc.dart';
import '../../../auctions/presentation/bloc/post_auction_bloc/post_auction_event.dart';
import '../../../auctions/presentation/bloc/post_auction_bloc/post_auction_state.dart';
import '../widgets/currency_selector.dart';
import '../widgets/duration_selector.dart';
import '../widgets/photo_picker_section.dart';

class PostAuctionPage extends StatefulWidget {
  const PostAuctionPage({super.key});

  @override
  State<PostAuctionPage> createState() => _PostAuctionPageState();
}

class _PostAuctionPageState extends State<PostAuctionPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _startingPriceController = TextEditingController();
  final _categoryController = TextEditingController();

  final _imagePicker = ImagePicker();
  final List<String> _imagePaths = [];

  String _selectedDuration = '6h';
  AppCurrency _selectedCurrency = AppCurrencies.defaultCurrency;

  final List<String> _durations = ['1h', '6h', '12h', '24h'];

  @override
  void dispose() {
    _titleController.dispose();
    _startingPriceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_imagePaths.length >= 3) return;

    final remainingSlots = 3 - _imagePaths.length;

    final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 80);

    if (pickedImages.isEmpty) return;

    final selectedPaths = pickedImages
        .take(remainingSlots)
        .map((image) => image.path)
        .toList();

    setState(() {
      _imagePaths.addAll(selectedPaths);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  Duration _durationFromLabel(String label) {
    switch (label) {
      case '1h':
        return const Duration(hours: 1);
      case '6h':
        return const Duration(hours: 6);
      case '12h':
        return const Duration(hours: 12);
      case '24h':
        return const Duration(hours: 24);
      default:
        return const Duration(hours: 6);
    }
  }

  void _submitAuction() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_imagePaths.isEmpty) {
      AppSnackbar.error(context, 'Please add at least one photo.');
      return;
    }

    final startingPrice = double.tryParse(_startingPriceController.text.trim());

    if (startingPrice == null || startingPrice <= 0) {
      AppSnackbar.error(context, 'Enter a valid starting price.');
      return;
    }

    context.read<PostAuctionBloc>().add(
      PostAuctionSubmitted(
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        currencyCode: _selectedCurrency.code,
        startingPrice: startingPrice,
        duration: _durationFromLabel(_selectedDuration),
        localImagePaths: List<String>.from(_imagePaths),
      ),
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  Future<void> _handlePostAuctionError(String message) async {
    AppSnackbar.error(context, message);

    if (!message.toLowerCase().contains('phone number')) return;

    final updated = await context.push<bool>(AppRoutes.editProfile);

    if (!mounted) return;

    if (updated == true) {
      AppSnackbar.success(
        context,
        'Phone number updated. You can post your auction now.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostAuctionBloc, PostAuctionState>(
      listener: (context, state) async {
        if (state is PostAuctionSuccess) {
          AppSnackbar.success(context, 'Auction posted successfully');
          Navigator.of(context).pop(true);
        }

        if (state is PostAuctionError) {
          await _handlePostAuctionError(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const AppBackBar(title: AppStrings.postAuction),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.pagePadding.w(context),
                ),
                child: SafeArea(
                  top: false,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SB.h(20),
                        PhotoPickerSection(
                          imagePaths: _imagePaths,
                          onAddPhoto: _pickImages,
                          onRemovePhoto: _removeImage,
                        ),
                        SB.h(24),
                        AppTextField(
                          controller: _titleController,
                          label: AppStrings.itemTitle,
                          hint: AppStrings.itemTitleHint,
                          validator: (value) =>
                              _requiredValidator(value, 'Title'),
                        ),
                        SB.h(16),
                        CurrencySelector(
                          selected: _selectedCurrency,
                          onSelected: (currency) {
                            setState(() => _selectedCurrency = currency);
                          },
                        ),
                        SB.h(16),
                        AppTextField(
                          controller: _startingPriceController,
                          label: AppStrings.startingPrice,
                          hint: '${_selectedCurrency.symbol} 0.00',
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              _requiredValidator(value, 'Starting price'),
                        ),
                        SB.h(16),
                        AppTextField(
                          controller: _categoryController,
                          label: AppStrings.category,
                          hint: AppStrings.categoryHint,
                          validator: (value) =>
                              _requiredValidator(value, 'Category'),
                        ),
                        SB.h(16),
                        DurationSelector(
                          options: _durations,
                          selected: _selectedDuration,
                          onSelected: (value) {
                            setState(() => _selectedDuration = value);
                          },
                        ),
                        SB.h(32),
                        BlocBuilder<PostAuctionBloc, PostAuctionState>(
                          builder: (context, state) {
                            final isLoading = state is PostAuctionLoading;

                            return AppButton(
                              text: AppStrings.postAuction,
                              isLoading: isLoading,
                              onPressed: isLoading ? null : _submitAuction,
                            );
                          },
                        ),
                        SB.h(24),
                      ],
                    ),
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
