import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  bool isEditing = false;

  final jamMulaiController = TextEditingController();
  final jamSelesaiController = TextEditingController();
  String? selectedPetugas;
  String? selectedDepartemen;
  String? selectedLokasi;

  File? selectedImage;
  final deskripsiController = TextEditingController();

  final List<String> petugasList = ['Javiero', 'Andhika', 'Budi'];
  final List<String> departemenList = ['ICT', 'HRD', 'Production'];
  final List<String> lokasiList = ['R. Software', 'Gudang', 'Workshop'];

  List<Map<String, dynamic>> rekapInspeksi = [];

  @override
  void initState() {
    super.initState();
    jamMulaiController.text = DateFormat('HH:mm').format(DateTime.now());
    // TODO: HAPUS setelah preview — hanya untuk melihat tampilan modal
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSuccessModal());
  }

  @override
  void dispose() {
    jamMulaiController.dispose();
    jamSelesaiController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  void startEdit() {
    setState(() {
      isEditing = true;
      jamMulaiController.text = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  void resetForm() {
    setState(() {
      selectedPetugas = null;
      selectedDepartemen = null;
      selectedLokasi = null;
      selectedImage = null;
      deskripsiController.clear();
      jamSelesaiController.clear();
    });
  }

  bool get lokasiAktif => selectedPetugas != null && selectedDepartemen != null;
  bool get detailAktif => selectedLokasi != null;
  bool get formValid =>
      selectedPetugas != null &&
      selectedDepartemen != null &&
      selectedLokasi != null &&
      selectedImage != null &&
      deskripsiController.text.isNotEmpty;

  Future pickImage() async {
    if (!detailAktif) return;
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void submitTemuan() {
    if (!formValid) return;
    setState(() {
      jamSelesaiController.text = DateFormat('HH:mm').format(DateTime.now());
      rekapInspeksi.add({
        'jamMulai': jamMulaiController.text,
        'jamSelesai': jamSelesaiController.text,
        'petugas': selectedPetugas,
        'departemen': selectedDepartemen,
        'lokasi': selectedLokasi,
        'deskripsi': deskripsiController.text,
        'image': selectedImage,
      });
      resetForm();
    });
  }

  Future<void> kirimKeApi() async {
    if (kDebugMode) print(rekapInspeksi);
    // TODO: ganti dengan http post ke backend
    try {
      // Simulasi API call
      await Future.delayed(const Duration(milliseconds: 500));
      // Anggap sukses — ganti with actual response check
      if (mounted) _showSuccessModal();
    } catch (e) {
      if (mounted) _showErrorToast('Gagal mengirim data. Coba lagi.');
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 338,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFCFCFD),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(20, 20, 20, 0.12),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge icon
              Image.asset(
                'assets/blue_success.png',
                width: 88,
                height: 84,
              ),
              const SizedBox(height: 12),
              // Title
              const Text(
                'Berhasil Submit',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF0086C9),
                  shadows: [
                    Shadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Button
              SizedBox(
                width: double.infinity,
                height: 38.51,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      rekapInspeksi.clear();
                      isEditing = false;
                      resetForm();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003A74),
                    side: const BorderSide(
                      color: Color(0xFF0086C9),
                      width: 0.84,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.35),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kembali ke Transaksi',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 11.72,
                      color: Color(0xFFF6FEF9),
                      shadows: [
                        Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFD92D20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  InputDecoration _fieldDecoration({bool disabled = false}) => InputDecoration(
    filled: true,
    fillColor: const Color(0xFFEAECF0),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xFF475467),
        letterSpacing: -0.02,
      ),
    ),
  );

  Widget _inputColumn({required String label, required Widget field}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_label(label), field],
  );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(color: const Color(0xFFD0D5DD)),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C65AD),
                          ),
                          children: [
                            TextSpan(text: 'Halo, '),
                            TextSpan(
                              text: 'Dhany',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF667085),
                          ),
                          children: [
                            TextSpan(text: 'Mari Mulai '),
                            TextSpan(
                              text: 'Inpeksi',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: isEditing ? null : startEdit,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C65AD),
                      disabledBackgroundColor: const Color(0xFF1C65AD).withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                    ),
                  ),
                ],
              ),
            ),

            // ── FORM ──────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: Jam Mulai + Jam Selesai
                    Row(
                      children: [
                        Expanded(
                          child: _inputColumn(
                            label: 'Jam Mulai :',
                            field: TextFormField(
                              enabled: false,
                              controller: jamMulaiController,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B6B6B),
                              ),
                              decoration: _fieldDecoration(disabled: true),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _inputColumn(
                            label: 'Jam Selesai :',
                            field: TextFormField(
                              enabled: false,
                              controller: jamSelesaiController,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B6B6B),
                              ),
                              decoration: _fieldDecoration(disabled: true),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Row: Petugas + Departemen
                    Row(
                      children: [
                        Expanded(
                          child: _inputColumn(
                            label: 'Petugas',
                            field: DropdownButtonFormField2<String>(
                              value: selectedPetugas,
                              hint: const Text(
                                'Pilih Petugas',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xFF101828),
                                ),
                              ),
                              items: petugasList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xFF475467),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isEditing
                                  ? (val) =>
                                        setState(() => selectedPetugas = val)
                                  : null,
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF575757),
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB5B5B5),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB5B5B5),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB5B5B5),
                                  ),
                                ),
                                filled: true,
                                fillColor: isEditing
                                    ? Colors.white
                                    : const Color(0xFFEAECF0),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  border: Border.all(
                                      color: const Color(0xFFB5B5B5)),
                                ),
                                padding: EdgeInsets.zero,
                                offset: const Offset(0, 0),
                              ),
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 34,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 34,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _inputColumn(
                            label: 'Departemen',
                            field: DropdownButtonFormField2<String>(
                              value: selectedDepartemen,
                              hint: const Text(
                                'Pilih Departemen',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xFF101828),
                                ),
                              ),
                              items: departemenList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xFF475467),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isEditing
                                  ? (val) =>
                                        setState(() => selectedDepartemen = val)
                                  : null,
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF575757),
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB5B5B5),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB5B5B5),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB5B5B5),
                                  ),
                                ),
                                filled: true,
                                fillColor: isEditing
                                    ? Colors.white
                                    : const Color(0xFFEAECF0),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  border: Border.all(
                                      color: const Color(0xFFB5B5B5)),
                                ),
                                padding: EdgeInsets.zero,
                                offset: const Offset(0, 0),
                              ),
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 34,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 34,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section divider: Detail Inspeksi
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF667085),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Detail Inspeksi',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFF1D2939),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Lokasi (full width)
                    // Di dalam _inputColumn
                    _inputColumn(
                      label: 'Lokasi',
                        field: DropdownButtonFormField2<String>(
                        value: selectedLokasi,
                        hint: const Text(
                          'Pilih Lokasi',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF101828),
                          ),
                        ),
                        items: lokasiList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color(0xFF475467),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: lokasiAktif
                            ? (val) => setState(() => selectedLokasi = val)
                            : null,
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF575757),
                          ),
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFB5B5B5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFB5B5B5),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFB5B5B5),
                            ),
                          ),
                          filled: true,
                          fillColor: lokasiAktif
                              ? Colors.white
                              : const Color(0xFFEAECF0),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            border: Border.all(color: const Color(0xFFB5B5B5)),
                          ),
                          padding: EdgeInsets.zero,
                          offset: const Offset(0, 0),
                        ),
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 34,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 34,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bukti Foto Inspeksi
                    _label('Bukti Foto Inspeksi'),
                    GestureDetector(
                      onTap: detailAktif ? pickImage : null,
                      child: Container(
                        width: double.infinity,
                        height: 135,
                        decoration: BoxDecoration(
                          color: detailAktif
                              ? Colors.white
                              : const Color(0xFFEAECF0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFD0D5DD),
                          ),
                        ),
                        child: selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: detailAktif
                                          ? const Color(0xFFEAECF0)
                                          : const Color(0xFFEAECF0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.upload_file_outlined,
                                      color: detailAktif
                                          ? const Color(0xFF194185)
                                          : const Color(0xFF98A2B3),
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Klik untuk Upload Foto',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: detailAktif
                                          ? const Color(0xFF0086C9)
                                          : const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'PNG, JPG files ( max 10mb )',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xFF98A2B3),
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Deskripsi
                    _inputColumn(
                      label: 'Deskripsi',
                      field: Stack(
                        children: [
                          TextField(
                            controller: deskripsiController,
                            enabled: detailAktif,
                            maxLines: 5,
                            maxLength: 500,
                            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                            style: TextStyle(
                              fontSize: 12,
                              color: detailAktif
                                  ? const Color(0xFF1D2939)
                                  : const Color(0xFF6B6B6B),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: detailAktif
                                  ? Colors.white
                                  : const Color(0xFFEAECF0),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  12, 8, 12, 28),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFFD0D5DD)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFFD0D5DD)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFFD0D5DD)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFF1C65AD), width: 1.5),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          if (detailAktif)
                            Positioned(
                              bottom: 8,
                              right: 12,
                              child: Text(
                                '${deskripsiController.text.length}/500 Character',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: Color(0xFF98A2B3),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Simpan Inspeksi button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: formValid ? submitTemuan : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C65AD),
                          disabledBackgroundColor: const Color(0xFF1C65AD).withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                        ),
                        child: const Text(
                          'Simpan Inspeksi',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── SUMMARY / FOOTER ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(color: const Color(0xFFD0D5DD)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Color.fromRGBO(0, 0, 0, 0.17),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Rekap row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rekap Temuan',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF0B4A6F),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAECF0),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${rekapInspeksi.length}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xFF1570EF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'total temuan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF475467),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Submit Temuan button
                  SizedBox(
                    width: double.infinity,
                    height: 41,
                    child: ElevatedButton(
                      onPressed: rekapInspeksi.isNotEmpty ? kirimKeApi : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003A74),
                        disabledBackgroundColor: const Color(0xFF003A74).withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit Temuan',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

