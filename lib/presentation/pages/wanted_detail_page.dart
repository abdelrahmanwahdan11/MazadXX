import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../controllers/wanted_detail_controller.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class WantedDetailPage extends StatefulWidget {
  const WantedDetailPage({super.key});

  @override
  State<WantedDetailPage> createState() => _WantedDetailPageState();
}

class _WantedDetailPageState extends State<WantedDetailPage> {
  final WantedDetailController controller = Get.find<WantedDetailController>();
  String? _loadedId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = Get.parameters['id'];
    if (id != null && id != _loadedId) {
      _loadedId = id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.load(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('wanted'.tr)),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final item = controller.item.value;
        if (isLoading && item == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (item == null) {
          return Center(child: Text('empty_state'.tr));
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Chip(label: Text('${'category'.tr}: ${item.category}')),
                      Chip(label: Text('${'location'.tr}: ${item.location}')),
                      Chip(label: Text('${'target_price'.tr}: ${controller.formatService.currency(item.targetPrice)}')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('${'specs'.tr}:\n${item.specs}'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _showOfferSheet(context, item),
                    child: Text('make_offer'.tr),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('message_requester'.tr),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(titleKey: 'offers'),
            const SizedBox(height: 12),
            Obx(() {
              final offers = controller.offers;
              if (offers.isEmpty) {
                return Center(child: Text('no_offers_yet'.tr));
              }
              return GlassCard(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: offers.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final Offer offer = offers[index];
                    return ListTile(
                      title: Text(controller.formatService.currency(offer.amount)),
                      subtitle: Text(offer.message),
                      trailing: Text(controller.formatService.dateTimeShort(offer.time)),
                    );
                  },
                ),
              );
            }),
          ],
        );
      }),
    );
  }

  Future<void> _showOfferSheet(BuildContext context, Wanted item) async {
    final amountController = TextEditingController();
    final messageController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('add_offer'.tr, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'amount'.tr),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                decoration: InputDecoration(labelText: 'message'.tr),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text);
                  final message = messageController.text.trim();
                  if (amount != null && message.isNotEmpty) {
                    controller.addOffer('u_01', amount, message);
                    Get.back<void>();
                  }
                },
                child: Text('submit_offer'.tr),
              ),
            ],
          ),
        );
      },
    );
  }
}
