import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portofolio_ilma/add_data.dart';
import 'package:portofolio_ilma/tentang_polije_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/portofolio_provider.dart';
import 'detail_project.dart';
final ValueNotifier<bool> appDarkMode = ValueNotifier<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => PortofolioProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: appDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Portfolio',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ),
            scaffoldBackgroundColor:
                const Color(0xFFF1F5F9),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor:
                const Color(0xFF121212),
            useMaterial3: true,
          ),
          themeMode: isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const MainScreen(),
        );
      },
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 1;

  final pages = const [
    HomePage(),
    ProfilePage(),
    PortofolioPage(),
    SettingsPage(),
    TentangPolijePage(),
  ];

  final titles = [
    'Selamat Datang di Portofolio Saya',
    'Menampilkan Karya dan Kemampuan Saya',
    'Showcase My Skills & Projects',
    'Atur Preferensi Aplikasi',
    'Informasi Politeknik Negeri Jember',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 25,
              left: 20,
              right: 20,
              bottom: 55,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '</>',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Portofolio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: pages[index]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() => index = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder),
            label: 'Portofolio',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Tentang POLIJE',
          ),
        ],
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;

  const CardBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}

// ==================== BERANDA ====================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortofolioProvider>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Halo, saya Ilma 👋',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Selamat datang di aplikasi portofolio saya. '
                'Buka Profil untuk melihat data diri dan keahlian, '
                'atau Portofolio untuk melihat proyek yang sudah saya kerjakan.',
              ),
            ],
          ),
        ),
        CardBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stat('${provider.projectCount}', 'Proyek'),
              Stat('${provider.technologyCount}', 'Teknologi'),
              Stat(provider.angkatan, 'Angkatan'),
            ],
          ),
        ),
      ],
    );
  }
}

class Stat extends StatelessWidget {
  final String value;
  final String label;

  const Stat(this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}

// ==================== EDIT PROFIL ====================

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late final TextEditingController namaController;
  late final TextEditingController bioController;

  Uint8List? fotoPilihan;

  @override
  void initState() {
    super.initState();

    final provider = context.read<PortofolioProvider>();

    namaController = TextEditingController(text: provider.nama);
    bioController = TextEditingController(text: provider.bio);
  }

  @override
  void dispose() {
    namaController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> pilihFoto() async {
    try {
      final picker = ImagePicker();

      final XFile? foto = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (foto == null) return;

      final bytes = await foto.readAsBytes();

      if (!mounted) return;

      setState(() {
        fotoPilihan = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $e'),
        ),
      );
    }
  }

  void simpanProfil() {
    if (namaController.text.trim().isEmpty ||
        bioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama dan Tentang Saya wajib diisi!'),
        ),
      );
      return;
    }

    final provider = context.read<PortofolioProvider>();

    provider.updateProfil(
      namaBaru: namaController.text.trim(),
      bioBaru: bioController.text.trim(),
      fotoBaru: provider.fotoProfil,
      angkatanBaru: provider.angkatan,
    );

    if (fotoPilihan != null) {
      provider.updateFotoProfil(fotoPilihan!);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
              ),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Tentang Saya',
                ),
              ),
              const SizedBox(height: 16),

              if (fotoPilihan != null) ...[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: MemoryImage(fotoPilihan!),
                ),
                const SizedBox(height: 10),
              ],

              OutlinedButton.icon(
                onPressed: pilihFoto,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Foto Profil'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: simpanProfil,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// ==================== PROFIL ====================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // FORM TAMBAH KEAHLIAN
  Future<void> tambahKeahlian(BuildContext context) async {
    final controller = TextEditingController();

    final skillBaru = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tambah Keahlian'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama Keahlian',
              hintText: 'Contoh: JavaScript',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    // Tidak mengakses controller lagi setelah dialog ditutup.
    // Provider akan mengabaikan skill kosong atau duplikat.
    if (!context.mounted || skillBaru == null) return;

    final provider = context.read<PortofolioProvider>();

    final jumlahSebelum = provider.skills.length;

    provider.tambahSkill(skillBaru);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.skills.length > jumlahSebelum
              ? 'Keahlian berhasil ditambahkan'
              : 'Keahlian kosong atau sudah tersedia',
        ),
      ),
    );
  }

  // KONFIRMASI HAPUS KEAHLIAN
  Future<void> hapusKeahlian(
    BuildContext context,
    String skill,
  ) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Keahlian'),
          content: Text(
            'Apakah kamu yakin ingin menghapus "$skill"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted || konfirmasi != true) return;

    context.read<PortofolioProvider>().hapusSkill(skill);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Keahlian berhasil dihapus'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortofolioProvider>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const EditProfilPage(),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profil'),
          ),
        ),
        const SizedBox(height: 12),

        // DATA PROFIL
        CardBox(
          child: Column(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: provider.fotoBytes != null
                    ? MemoryImage(provider.fotoBytes!)
                    : AssetImage(provider.fotoProfil),
              ),
              const SizedBox(height: 12),
              Text(
                provider.nama,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Mahasiswa Teknik Informatika'),
              const Divider(height: 30),
              const Info('NIM', 'E41251255'),
              const Info('Program Studi', 'Teknik Informatika'),
              const Info('Politeknik', 'PSDKU 3 Nganjuk'),
            ],
          ),
        ),

        // TENTANG SAYA
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tentang Saya',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(provider.bio),
            ],
          ),
        ),

        // KEAHLIAN & TEKNOLOGI
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Keahlian & Teknologi',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => tambahKeahlian(context),
                    icon: const Icon(Icons.add_circle),
                    color: const Color(0xFF2563EB),
                    tooltip: 'Tambah Keahlian',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (provider.skills.isEmpty)
                const Text('Belum ada keahlian.')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.skills.map((skill) {
                    return InputChip(
                      label: Text(skill),
                      onDeleted: () {
                        hapusKeahlian(context, skill);
                      },
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 18,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),

        // KONTAK & SOSIAL MEDIA
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Kontak & Sosial Media',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('Email: ilmafadhilah@gmail.com'),
              Text('Instagram: @ilmafdh_'),
              Text('GitHub: github.com/ilmafdh'),
            ],
          ),
        ),
      ],
    );
  }
}

class Info extends StatelessWidget {
  final String title;
  final String value;

  const Info(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(title),
          ),
          Expanded(
            child: Text(': $value'),
          ),
        ],
      ),
    );
  }
}



 // ==================== PORTOFOLIO ====================

class PortofolioPage extends StatefulWidget {
  const PortofolioPage({super.key});

  @override
  State<PortofolioPage> createState() => _PortofolioPageState();
}

class _PortofolioPageState extends State<PortofolioPage> {
  // DETAIL PROJECT
  void lihatDetailProject(Map<String, String> project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProjectPage(
          project: project,
        ),
      ),
    );
  }

  // TAMBAH PROJECT
  Future<void> tambahProject() async {
    final hasil = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDataPage(),
      ),
    );

    if (!mounted || hasil == null) return;

    context.read<PortofolioProvider>().tambahProject({
      'nama': hasil['nama'] ?? '',
      'tahun': DateTime.now().year.toString(),
      'teknologi': 'Belum ditentukan',
      'deskripsi': hasil['deskripsi'] ?? '',
    });
  }

  // EDIT PROJECT
  Future<void> editProject(int index) async {
    final provider = context.read<PortofolioProvider>();

    final project = Map<String, String>.from(
      provider.projects[index],
    );

    final hasil = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddDataPage(
          nama: project['nama'],
          deskripsi: project['deskripsi'],
        ),
      ),
    );

    if (!mounted || hasil == null) return;

    provider.editProject(index, {
      ...project,
      'nama': hasil['nama'] ?? '',
      'deskripsi': hasil['deskripsi'] ?? '',
    });
  }

  // HAPUS PROJECT
  Future<void> hapusProject(int index) async {
    final provider = context.read<PortofolioProvider>();

    final nama =
        provider.projects[index]['nama'] ?? 'Project ini';

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Project'),
          content: Text(
            'Apakah kamu yakin ingin menghapus "$nama"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || konfirmasi != true) return;

    provider.hapusProject(index);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project berhasil dihapus'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects =
        context.watch<PortofolioProvider>().projects;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: tambahProject,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Project'),
          ),
        ),
        const SizedBox(height: 12),

        ...projects.asMap().entries.map((entry) {
          final index = entry.key;
          final project = entry.value;

          return CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['nama'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Tahun: ${project['tahun'] ?? '-'}'),
                Text(
                  'Teknologi: ${project['teknologi'] ?? '-'}',
                ),
                const SizedBox(height: 10),
                Text(project['deskripsi'] ?? ''),
                const SizedBox(height: 12),

                // TOMBOL DETAIL, EDIT, DAN HAPUS
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        lihatDetailProject(project);
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('Lihat Detail'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        editProject(index);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        hapusProject(index);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: const Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}


// ==================== PENGATURAN ====================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notification = true;
  bool darkMode = appDarkMode.value;

  @override
  void initState() {
    super.initState();
    darkMode = appDarkMode.value;
  }

  void ubahNotifikasi(bool value) {
    setState(() {
      notification = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Notifikasi simulasi diaktifkan.'
              : 'Notifikasi simulasi dinonaktifkan.',
        ),
      ),
    );
  }

  void ubahModeGelap(bool value) {
    setState(() {
      darkMode = value;
    });

    appDarkMode.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        CardBox(
          child: Column(
            children: [
              SwitchListTile(
                value: notification,
                onChanged: ubahNotifikasi,
                title: const Text('Notifikasi'),
                secondary: const Icon(Icons.notifications),
              ),
              SwitchListTile(
                value: darkMode,
                onChanged: ubahModeGelap,
                title: const Text('Mode Gelap'),
                secondary: const Icon(Icons.dark_mode),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Tentang Aplikasi'),
                subtitle: Text('My Portofolio v1.0.0'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}