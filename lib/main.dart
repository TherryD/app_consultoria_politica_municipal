import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/dados_estacao_model.dart';
import 'services/eleicao_service.dart';

void main() {
  runApp(MaterialApp(
    title: 'Consultoria Política Estação/RS',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    home: const PaginaPrincipal(),
  ));
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indiceAba = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DadosEstacaoModel>(
      future: EleicaoService.obterDados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Erro ao carregar dados locais: ${snapshot.error}\n\n'
                      'Verifique se "assets/data/estacao_dados.json" está configurado no pubspec.yaml.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final dados = snapshot.data!;

        final List<Widget> abas = [
          _AbaSimulador(dados: dados),
          _AbaContabilidade(dados: dados),
          _AbaMarketingDiscurso(dados: dados),
          _AbaInformacoesEstacao(dados: dados),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text('${dados.tema} | ${dados.municipio}-${dados.uf}'),
            centerTitle: true,
          ),
          body: abas[_indiceAba],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _indiceAba,
            onDestinationSelected: (idx) => setState(() => _indiceAba = idx),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.how_to_vote), label: 'Votação'),
              NavigationDestination(icon: Icon(Icons.calculate), label: 'Calculadora'),
              NavigationDestination(icon: Icon(Icons.record_voice_over), label: 'Discursos'),
              NavigationDestination(icon: Icon(Icons.location_city), label: 'Estação/RS'),
            ],
          ),
        );
      },
    );
  }
}

// ABA 1: Simulador Eleitoral (Ano / Quantidade / Probabilidade)

class _AbaSimulador extends StatefulWidget {
  final DadosEstacaoModel dados;
  const _AbaSimulador({required this.dados});

  @override
  State<_AbaSimulador> createState() => _AbaSimuladorState();
}

class _AbaSimuladorState extends State<_AbaSimulador> {
  final _ctrlValidos = TextEditingController(text: '4120');
  final _ctrlMeta = TextEditingController(text: '230');
  Map<String, String>? _analise;
  int _qe = 0;

  @override
  void dispose() {
    _ctrlValidos.dispose();
    _ctrlMeta.dispose();
    super.dispose();
  }

  void _calcular() {
    final validos = int.tryParse(_ctrlValidos.text) ?? 0;
    final meta = int.tryParse(_ctrlMeta.text) ?? 0;
    final qeCalc = EleicaoService.calcularQE(validos, widget.dados.ibge.vagasCamara);

    setState(() {
      _qe = qeCalc;
      _analise = EleicaoService.avaliarProbabilidade(meta, qeCalc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Simulador de Votos e Probabilidade',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Câmara de Vereadores de Estação: ${widget.dados.ibge.vagasCamara} vagas'),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrlValidos,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Apenas números
          decoration: const InputDecoration(
            labelText: 'Votos Válidos Totais Projetados',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrlMeta,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Apenas números
          decoration: const InputDecoration(
            labelText: 'Meta Nominal do Candidato',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _calcular,
          icon: const Icon(Icons.analytics),
          label: const Text('Calcular Probabilidade'),
        ),
        const SizedBox(height: 16),
        if (_analise != null)
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quociente Eleitoral (QE): $_qe votos',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Cláusula Individual (10%): ${EleicaoService.calcularBarreiraIndividual(_qe)} votos',
                  ),
                  const Divider(),
                  Text('Status: ${_analise!['status']}'),
                  Text(
                    'Probabilidade: ${_analise!['probabilidade']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(_analise!['mensagem']!),
                ],
              ),
            ),
          ),
        const SizedBox(height: 20),
        const Text(
          'Histórico Eleitoral Municipal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.dados.historicoEleicoes.map((h) => Card(
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text('Ano ${h.ano} - Votos Válidos: ${h.votosValidos}'),
            subtitle: Text('QE: ${h.quocienteEleitoral} | Barreira Mínima: ${h.clausulaBarreira10} votos'),
          ),
        )),
      ],
    );
  }
}

// ABA 2: Calculadora Orçamentária e Contabilidade

class _AbaContabilidade extends StatefulWidget {
  final DadosEstacaoModel dados;
  const _AbaContabilidade({required this.dados});

  @override
  State<_AbaContabilidade> createState() => _AbaContabilidadeState();
}

class _AbaContabilidadeState extends State<_AbaContabilidade> {
  late final TextEditingController _ctrlTeto;

  @override
  void initState() {
    super.initState();
    _ctrlTeto = TextEditingController(
      text: widget.dados.contabilidade.tetoVereador.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _ctrlTeto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teto = double.tryParse(_ctrlTeto.text.replaceAll(',', '.')) ?? 0.0;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Calculadora de Gastos de Campanha',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrlTeto,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}')),
          ],
          decoration: const InputDecoration(
            labelText: 'Teto Total de Gastos (R\$)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        const Text(
          'Distribuição Recomendada por Rubrica:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.dados.contabilidade.divisaoSugerida.map((div) {
          final double pct = (div['percentual'] as num).toDouble();
          final valor = teto * (pct / 100);
          return Card(
            child: ListTile(
              title: Text('${div['categoria']} ($pct%)'),
              subtitle: Text(div['descricao']),
              trailing: Text(
                'R\$ ${valor.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ABA 3: Marketing, Roteiros de Fala e Corretor Ortográfico
class _AbaMarketingDiscurso extends StatefulWidget {
  final DadosEstacaoModel dados;
  const _AbaMarketingDiscurso({required this.dados});

  @override
  State<_AbaMarketingDiscurso> createState() => _AbaMarketingDiscursoState();
}

class _AbaMarketingDiscursoState extends State<_AbaMarketingDiscurso> {
  final _ctrlDiscurso = TextEditingController();
  List<String> _avisos = [];

  @override
  void dispose() {
    _ctrlDiscurso.dispose();
    super.dispose();
  }

  void _analisar() {
    setState(() {
      _avisos = EleicaoService.verificarDiscurso(
        _ctrlDiscurso.text,
        widget.dados.termosCorretor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Verificador e Corretor de Termos Eleitorais',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _ctrlDiscurso,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Escreva ou cole a legenda do post, panfleto ou discurso...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _analisar,
          icon: const Icon(Icons.spellcheck),
          label: const Text('Verificar Conformidade'),
        ),
        const SizedBox(height: 8),
        if (_avisos.isNotEmpty)
          ..._avisos.map((av) => Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: Text(av),
            ),
          ))
        else if (_ctrlDiscurso.text.isNotEmpty)
          Card(
            color: Colors.green.shade50,
            child: const ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Texto em conformidade eleitoral.'),
            ),
          ),
        const Divider(height: 32),
        const Text(
          'Roteiros de Marketing e Falas para Estação',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.dados.marketingFalas.map((m) => Card(
          child: ListTile(
            leading: const Icon(Icons.campaign),
            title: Text(m.tema, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(m.roteiroSugerido),
          ),
        )),
      ],
    );
  }
}

// ABA 4: Dados de Estação, MEF, Políticas Públicas e FAQ

class _AbaInformacoesEstacao extends StatelessWidget {
  final DadosEstacaoModel dados;
  const _AbaInformacoesEstacao({required this.dados});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IBGE: ${dados.municipio} - ${dados.uf}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text('• População (Censo 2022): ${dados.ibge.populacaoCenso2022} hab.'),
                Text('• População Estimada (2026): ${dados.ibge.populacaoEstimada2026} hab.'),
                Text('• Área: ${dados.ibge.areaTerritorialKm2} km²'),
                Text('• PIB per capita: R\$ ${dados.ibge.pibPerCapita.toStringAsFixed(2)}'),
                Text('• Escolarização 6-14 anos: ${dados.ibge.escolarizacao}%'),
                Text('• Orçamento Receitas Brutas: R\$ ${dados.ibge.receitasBrutas.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ExpansionTile(
            title: const Text(
              'Calendário Eleitoral e Prazos MEF',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: dados.calendarioMef
                .map((m) => ListTile(
              title: Text(m.etapa),
              subtitle: Text('${m.prazo} - ${m.descricao}'),
            ))
                .toList(),
          ),
        ),
        Card(
          child: ExpansionTile(
            title: const Text(
              'Feriados Municipais de Estação',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: dados.feriadosMunicipais
                .map((f) => ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(f.nome),
              trailing: Text(f.data, style: const TextStyle(fontWeight: FontWeight.bold)),
            ))
                .toList(),
          ),
        ),
        Card(
          child: ExpansionTile(
            title: const Text(
              'Políticas Públicas e Propostas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: dados.politicasPublicas
                .map((p) => ListTile(
              title: Text(p.eixo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p.secretaria}\n${p.politica}'),
            ))
                .toList(),
          ),
        ),
        Card(
          child: ExpansionTile(
            title: const Text(
              'Perguntas Frequentes (FAQ)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: dados.faq
                .map((item) => ListTile(
              title: Text(item.pergunta, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.resposta),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }
}