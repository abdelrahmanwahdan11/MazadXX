import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/local_store.dart';

class PostController extends GetxController {
  PostController({required this.localStore, required this.actionLog});

  final LocalStore localStore;
  final ActionLog actionLog;

  final RxInt currentStep = 0.obs;
  final RxString mode = 'auction'.obs;
  final RxMap<String, dynamic> form = <String, dynamic>{}.obs;
  final RxBool previewMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  void setMode(String value) {
    mode.value = value;
    actionLog.add('post_mode:$value');
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void updateField(String key, dynamic value) {
    form[key] = value;
    saveDraft();
  }

  Future<void> saveDraft() async {
    await localStore.writeJson('post_draft', form);
  }

  Future<void> _loadDraft() async {
    final draft = localStore.readJson('post_draft');
    if (draft != null) {
      form.assignAll(draft);
    }
  }

  Future<void> submit() async {
    actionLog.add('post_submit:${mode.value}');
    previewMode.value = false;
    await localStore.writeJson('post_${mode.value}_${DateTime.now().millisecondsSinceEpoch}', form);
  }

  void togglePreview() {
    previewMode.toggle();
  }
}
