import 'package:flutter/material.dart';

class TentangPolijePage extends StatefulWidget {
  const TentangPolijePage({super.key});

  @override
  State<TentangPolijePage> createState() =>
      _TentangPolijePageState();
}

class _TentangPolijePageState extends State<TentangPolijePage> {
  String programDipilih = 'Teknik Informatika';

  final List<Map<String, String>> programStudi = [
    {
      'nama': 'Teknik Informatika',
      'deskripsi': 'Program Sarjana Terapan (D4). '
          'POLIJE memiliki Program Studi Teknik Informatika '
          'di Kampus Nganjuk.',
    },
    {
      'nama': 'Manajemen Informatika',
      'deskripsi': 'Informasi jenjang dan lokasi program '
          'dapat diperiksa melalui direktori resmi POLIJE.',
    },
    {
      'nama': 'Teknik Komputer',
      'deskripsi': 'Program studi yang berkaitan dengan '
          'perangkat keras komputer dan sistem komputer.',
    },
  ];

  final PageController pageController = PageController();

  final List<Map<String, dynamic>> informasi = [
    {
      'judul': 'Fasilitas Kampus',
      'ikon': Icons.computer,
      'isi': 'Informasi fasilitas pembelajaran dan laboratorium '
          'dapat dilihat melalui situs resmi POLIJE.',
    },
    {
      'judul': 'Kegiatan Mahasiswa',
      'ikon': Icons.groups,
      'isi': 'Mahasiswa dapat mengembangkan potensi melalui '
          'organisasi, kegiatan akademik, dan kegiatan nonakademik.',
    },
    {
      'judul': 'Kerja Sama Industri',
      'ikon': Icons.business,
      'isi': 'Pendidikan vokasi POLIJE berorientasi pada '
          'keterampilan terapan dan kebutuhan dunia kerja.',
    },
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void tambahProgram() {
    tampilkanForm();
  }

  void editProgram(int index) {
    tampilkanForm(index: index);
  }

  Future<void> tampilkanForm({int? index}) async {
    if (!mounted) return;

    final bool sedangEdit = index != null;

    final hasil = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return FormProgramDialog(
          judul: sedangEdit
              ? 'Edit Program Studi'
              : 'Tambah Program Studi',
          namaAwal:
              sedangEdit ? programStudi[index]['nama']! : '',
          deskripsiAwal: sedangEdit
              ? programStudi[index]['deskripsi']!
              : '',
          namaSudahAda: (nama) {
            return programStudi.asMap().entries.any((entry) {
              if (sedangEdit && entry.key == index) {
                return false;
              }

              return entry.value['nama']!.toLowerCase() ==
                  nama.trim().toLowerCase();
            });
          },
        );
      },
    );

    if (!mounted || hasil == null) return;

    setState(() {
      if (sedangEdit) {
        final namaLama = programStudi[index]['nama'];

        programStudi[index] = {
          'nama': hasil['nama']!,
          'deskripsi': hasil['deskripsi']!,
        };

        if (programDipilih == namaLama) {
          programDipilih = hasil['nama']!;
        }
      } else {
        programStudi.add({
          'nama': hasil['nama']!,
          'deskripsi': hasil['deskripsi']!,
        });

        programDipilih = hasil['nama']!;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sedangEdit
              ? 'Program studi berhasil diperbarui'
              : 'Program studi berhasil ditambahkan',
        ),
      ),
    );
  }

  Future<void> hapusProgram(int index) async {
    final nama = programStudi[index]['nama']!;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Program Studi'),
          content: Text(
            'Apakah kamu yakin ingin menghapus "$nama"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || konfirmasi != true) return;

    setState(() {
      final namaDihapus = programStudi[index]['nama'];

      programStudi.removeAt(index);

      if (programStudi.isEmpty) {
        programDipilih = '';
      } else if (programDipilih == namaDihapus) {
        programDipilih = programStudi.first['nama']!;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Program studi berhasil dihapus'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2563EB),
                Color(0xFF7C3AED),
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.school,
                color: Colors.white,
                size: 42,
              ),
              SizedBox(height: 12),
              Text(
                'Tentang POLIJE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Politeknik Negeri Jember',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Profil Kampus',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on,
                    color: Color(0xFF2563EB),
                  ),
                  title: Text('Lokasi Kampus Pusat'),
                  subtitle: Text(
                    'Jl. Mastrip, Jember, Jawa Timur',
                  ),
                ),
                Divider(),
                Text(
                  'POLIJE merupakan perguruan tinggi vokasi '
                  'yang menekankan pembelajaran praktis, '
                  'keterampilan terapan, dan kesiapan kerja.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Program Studi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: tambahProgram,
            icon: const Icon(Icons.add),
            label: const Text('+ Tambah Program Studi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),

        if (programStudi.isNotEmpty)
          DropdownButtonFormField<String>(
            key: ValueKey(programDipilih),
            initialValue: programDipilih,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Pilih program studi',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.menu_book),
            ),
            items: programStudi.map((program) {
              return DropdownMenuItem<String>(
                value: program['nama']!,
                child: Text(program['nama']!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  programDipilih = value;
                });
              }
            },
          )
        else
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Belum ada program studi. Silakan tambah data.',
              ),
            ),
          ),

        const SizedBox(height: 12),

        ...programStudi.asMap().entries.map((entry) {
          final index = entry.key;
          final program = entry.value;
          final nama = program['nama']!;
          final deskripsi = program['deskripsi']!;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.school,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(deskripsi),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => editProgram(index),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () => hapusProgram(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 20),
        const Text(
          'Kehidupan Kampus',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: pageController,
            itemCount: informasi.length,
            itemBuilder: (context, index) {
              final item = informasi[index];

              return Card(
                margin: const EdgeInsets.only(right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item['ikon'] as IconData,
                        size: 34,
                        color: const Color(0xFF2563EB),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['judul'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item['isi'] as String),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sumber informasi:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const SelectableText(
          'polije.ac.id\n'
          'polije.ac.id/teknik-informatika-nganjuk/',
        ),
      ],
    );
  }
}

class FormProgramDialog extends StatefulWidget {
  final String judul;
  final String namaAwal;
  final String deskripsiAwal;
  final bool Function(String nama) namaSudahAda;

  const FormProgramDialog({
    super.key,
    required this.judul,
    required this.namaAwal,
    required this.deskripsiAwal,
    required this.namaSudahAda,
  });

  @override
  State<FormProgramDialog> createState() =>
      _FormProgramDialogState();
}

class _FormProgramDialogState extends State<FormProgramDialog> {
  late final TextEditingController namaController;
  late final TextEditingController deskripsiController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.namaAwal);
    deskripsiController =
        TextEditingController(text: widget.deskripsiAwal);
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.judul),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Program Studi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama program studi wajib diisi';
                  }

                  if (widget.namaSudahAda(value)) {
                    return 'Nama program studi sudah ada';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: deskripsiController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi / Informasi',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }

                  return null;
                },
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
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            Navigator.pop(
              context,
              {
                'nama': namaController.text.trim(),
                'deskripsi': deskripsiController.text.trim(),
              },
            );
          },
          child: Text(
            widget.judul.startsWith('Edit') ? 'Simpan' : 'Tambah',
          ),
        ),
      ],
    );
  }
}