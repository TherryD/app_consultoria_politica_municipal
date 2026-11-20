import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dados_estacao_model.dart';

class EleicaoService {
  static DadosEstacaoModel? _dadosCarregados;

  // Carrega e memoriza os dados do JSON
  static Future<DadosEstacaoModel> obterDados() async {
    if (_dadosCarregados != null) return _dadosCarregados!;

    final String conteudo = await rootBundle.loadString('assets/data/estacao_dados.json');
    final Map<String, dynamic> mapa = json.decode(conteudo);
    _dadosCarregados = DadosEstacaoModel.fromJson(mapa);
    return _dadosCarregados!;
  }

  // Quociente Eleitoral (QE) = Votos Válidos / Cadeiras na Câmara (9 vagas em Estação)
  static int calcularQE(int votosValidos, [int vagas = 9]) {
    if (vagas <= 0) return 0;
    return (votosValidos / vagas).floor();
  }

  // Cláusula de barreira individual de 10% do QE
  static int calcularBarreiraIndividual(int qe) {
    return (qe * 0.10).ceil();
  }

  // Avaliação de probabilidade do candidato com base nos dados do quadro
  static Map<String, String> avaliarProbabilidade(int metaVotos, int qe) {
    final corte = calcularBarreiraIndividual(qe);

    if (metaVotos < corte) {
      return {
        'status': 'Inapto (Cláusula de Barreira)',
        'probabilidade': 'Muito Baixa',
        'mensagem': 'Abaixo da barreira individual mínima ($corte votos nominais necessários).',
      };
    }

    final percentual = (metaVotos / qe) * 100;

    if (percentual >= 80) {
      return {
        'status': 'Competitivo Direto',
        'probabilidade': 'Alta',
        'mensagem': 'Forte probabilidade de conquista de vaga direta pelo Quociente Partidário.',
      };
    } else if (percentual >= 40) {
      return {
        'status': 'Disputa de Sobras',
        'probabilidade': 'Média',
        'mensagem': 'Viável na disputa da distribuição das sobras eleitorais.',
      };
    } else {
      return {
        'status': 'Composição de Legenda',
        'probabilidade': 'Baixa',
        'mensagem': 'Ajuda a somar para a chapa partidária, mas com baixa probabilidade individual.',
      };
    }
  }

  // Verificador de discurso contra termos vedados
  static List<String> verificarDiscurso(String texto, List<TermoCorretor> termos) {
    final List<String> avisos = [];
    final textoMinusculo = texto.toLowerCase();

    for (final t in termos) {
      if (textoMinusculo.contains(t.termo.toLowerCase())) {
        avisos.add('${t.termo.toUpperCase()}: ${t.correcao}');
      }
    }
    return avisos;
  }
}