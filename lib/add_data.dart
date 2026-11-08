import 'package:flutter/material.dart';

class AddDataPage extends StatefulWidget {
  final String? nama;
  final String? deskripsi;

  const AddDataPage({
    super.key,
    this.nama,
    this.deskripsi,
  });

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  late final TextEditingController namaController;
  late final TextEditingController deskripsiController;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(
      text: widget.nama ?? '',
    );

    deskripsiController = TextEditingController(
      text: widget.deskripsi ?? '',
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sedangEdit = widget.nama != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sedangEdit ? 'Edit Project' : 'Tambah Project',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Project',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Project',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final nama = namaController.text.trim();
                  final deskripsi =
                      deskripsiController.text.trim();

                  if (nama.isEmpty || deskripsi.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Semua kolom harus diisi'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'nama': nama,
                    'deskripsi': deskripsi,
                  });
                },
                child: Text(
                  sedangEdit ? 'Simpan Perubahan' : 'Simpan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}