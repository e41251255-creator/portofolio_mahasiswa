import 'dart:typed_data';
import 'package:flutter/material.dart';

class PortofolioProvider extends ChangeNotifier {
  String nim = 'E41251255';

  String get angkatan {
    if (nim.length < 5) return '';
    String tahun = nim.substring(3, 5);
    return '20$tahun';
  }

  // DATA PROFIL
  String nama = 'Ilma Nur Fadhilah';

  String bio =
      'Saya adalah mahasiswa Teknik Informatika yang tertarik '
      'pada pengembangan aplikasi, desain UI/UX, dan teknologi digital.';

  String fotoProfil = 'assets/images/foto formal kuu.jpeg';

  // Foto baru yang dipilih dari folder laptop
  Uint8List? fotoBytes;

  void updateProfil({
    required String namaBaru,
    required String bioBaru,
    required String fotoBaru,
    required String angkatanBaru,
  }) {
    nama = namaBaru;
    bio = bioBaru;
    fotoProfil = fotoBaru;
    notifyListeners();
  }

  void updateFotoProfil(Uint8List fotoBaru) {
    fotoBytes = fotoBaru;
    notifyListeners();
  }

  // KEAHLIAN & TEKNOLOGI
  List<String> skills = [
    'Flutter',
    'Dart',
    'HTML',
    'CSS',
    'Figma',
    'Laravel',
  ];

  void tambahSkill(String skill) {
    final skillBaru = skill.trim();

    if (skillBaru.isEmpty) return;

    // Mencegah skill yang sama ditambahkan dua kali
    final sudahAda = skills.any(
      (item) => item.toLowerCase() == skillBaru.toLowerCase(),
    );

    if (sudahAda) return;

    skills.add(skillBaru);
    notifyListeners();
  }

  void hapusSkill(String skill) {
    skills.remove(skill);
    notifyListeners();
  }

  // DATA PORTOFOLIO
  final List<Map<String, String>> projects = [
    {
      'nama': 'Website Seblak Say',
      'tahun': '2025',
      'teknologi': 'Flutter, Dart, Figma',
      'deskripsi':
          'Proyek yang saya kerjakan untuk mengembangkan '
          'kemampuan di bidang teknologi.',
      'gambar': '',
    },
    {
      'nama': 'Website El-Fath Fotokopi',
      'tahun': '2025',
      'teknologi': 'Flutter, Dart, Firebase',
      'deskripsi':
          'Proyek yang saya kerjakan untuk mengembangkan '
          'kemampuan di bidang teknologi.',
      'gambar': '',
    },
    {
      'nama': 'Aplikasi Portofolio Mahasiswa',
      'tahun': '2026',
      'teknologi': 'Flutter, Dart, Firebase',
      'deskripsi':
          'Aplikasi untuk menampilkan profil, keterampilan, '
          'dan hasil karya mahasiswa.',
      'gambar': '',
    },
    {
      'nama': 'Aplikasi Kasir UMKM',
      'tahun': '2024',
      'teknologi': 'Flutter, Dart',
      'deskripsi':
          'Aplikasi untuk membantu proses pencatatan '
          'transaksi dan pengelolaan penjualan UMKM.',
      'gambar': '',
    },
    {
      'nama': 'Rancangan UI/UX Aplikasi Mobile',
      'tahun': '2026',
      'teknologi': 'Figma',
      'deskripsi':
          'Perancangan antarmuka dan pengalaman pengguna '
          'untuk aplikasi mobile yang mudah digunakan.',
      'gambar': '',
    },
  ];

  int get projectCount => projects.length;

  int get technologyCount => skills.length;

  void tambahProject(Map<String, String> project) {
    projects.add(project);
    notifyListeners();
  }

  void editProject(int index, Map<String, String> project) {
    projects[index] = project;
    notifyListeners();
  }

  void hapusProject(int index) {
    projects.removeAt(index);
    notifyListeners();
  }

  void updateAngkatan(String value) {
    // Angkatan dihitung otomatis dari NIM.
    // Nilai angkatan tidak diubah secara manual.
    notifyListeners();
  }
}