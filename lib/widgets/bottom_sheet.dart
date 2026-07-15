import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart"; 

import "../l10n/app_localizations.dart";
import "../theme/app_theme.dart";
import "../features/grave/presentation/providers/grave_details_provider.dart";

import "detail_views/bottom_sheet_handler.dart";
import "detail_views/feedback_section.dart";
import "detail_views/profile_icon_widget.dart";
import "details_section.dart";
import "grave_action_buttons.dart";
import "image_carousel.dart";

class MyDraggableSheet extends ConsumerStatefulWidget {
  // Для теста добавим graveId, чтобы знать какую могилу загружать
  final String graveId; 
  const MyDraggableSheet({super.key, this.graveId = "mock_grave_id"});

  @override
  ConsumerState<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends ConsumerState<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(0.05); // подправь если у тебя тут snapSizes

  Future<void> _animateSheet(double size) async {
    await _controller.animateTo(size, duration: const Duration(milliseconds: 50), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. «Слушаем» состояние деталей могилы
    final graveState = ref.watch(graveDetailsProvider(widget.graveId));

    return DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.5,
      minChildSize: 0.05,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.05, 0.5, 0.95],
      controller: _controller,
      builder: (context, scrollController) {
        return Card(
          color: context.colorScheme.surface,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          ),
          child: Stack(
            children: [
              BottomSheetHandler(),
              Padding(
                padding: const EdgeInsets.only(top: 21),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        
                    
                        graveState.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (err, stack) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: Text("Błąd ładowania: $err")),
                          ),
                          data: (grave) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Выводим РЕАЛЬНЫЕ имя и фамилию из пришедшей модельки
                                        Text(
                                          "${grave.firstName} ${grave.lastName}",
                                          style: context.textTheme.headlineMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        // Если в модели нет дат, пока оставляем локализацию
                                        Text(
                                          AppLocalizations.of(context)!.birth_death_dates,
                                          style: context.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    ProfileIconWidget(),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Передаем graveId в кнопки действий, чтобы кликать по ним
                                GraveActionButtons(graveId: widget.graveId),
                                
                                const SizedBox(height: 16),
                                ImageCarousel(),
                                const SizedBox(height: 16),
                                
                                // Передаем биографию/модельку в нижнюю секцию с табами
                                DetailsSection(biography: grave.biography ?? ""),
                                
                                const SizedBox(height: 8),
                                FeedbackSection(),
                                const SizedBox(height: 32),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}