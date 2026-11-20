import 'package:flutter_test/flutter_test.dart';
import 'package:app_consultoria_politica_municipal/models/dados_estacao_model.dart';
import 'package:app_consultoria_politica_municipal/services/eleicao_service.dart';

void main() {
  group('Testes de Lógica Eleitoral - Estação/RS', () {
    test('Deve calcular o Quociente Eleitoral corretamente para 9 vagas', () {
      // 4.120 votos válidos divididos por 9 cadeiras na câmara
      const votosValidos = 4120;
      final qe = EleicaoService.calcularQE(votosValidos, 9);

      // 4120 / 9 = 457.77... -> floor() = 457
      expect(qe, equals(457));
    });

    test('Deve calcular a Cláusula de Barreira Individual (10% do QE)', () {
      const qe = 457;
      final barreira = EleicaoService.calcularBarreiraIndividual(qe);

      // 457 * 0.10 = 45.7 -> ceil() = 46
      expect(barreira, equals(46));
    });

    test('Deve classificar candidato abaixo da cláusula como inapto', () {
      const qe = 457;
      const metaVotosAbaixo = 30; // Menor que 46

      final resultado = EleicaoService.avaliarProbabilidade(metaVotosAbaixo, qe);

      expect(resultado['probabilidade'], equals('Muito Baixa'));
      expect(resultado['status'], contains('Inapto'));
    });

    test('Deve alertar sobre termos proibidos no discurso', () {
      final termosMock = [
        TermoCorretor(
          termo: 'showmicio',
          status: 'proibido',
          correcao: 'Showmício é proibido.',
        ),
      ];

      final avisos = EleicaoService.verificarDiscurso(
        'Vamos realizar um grande showmicio neste fim de semana.',
        termosMock,
      );

      expect(avisos.length, equals(1));
      expect(avisos.first, contains('SHOWMICIO'));
    });
  });
}