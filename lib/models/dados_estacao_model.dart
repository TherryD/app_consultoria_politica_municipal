class DadosEstacaoModel {
  final String municipio;
  final String uf;
  final String publicoAlvo;
  final String tema;
  final int codigoIbge;
  final String gentilico;
  final DadosIbge ibge;
  final List<HistoricoEleicao> historicoEleicoes;
  final RegrasProbabilidade regrasProbabilidade;
  final ContabilidadeCalculadora contabilidade;
  final List<EtapaCalendario> calendarioMef;
  final List<FeriadoMunicipal> feriadosMunicipais;
  final List<PoliticaPublica> politicasPublicas;
  final List<RoteiroMarketing> marketingFalas;
  final List<TermoCorretor> termosCorretor;
  final List<ItemFaq> faq;

  DadosEstacaoModel({
    required this.municipio,
    required this.uf,
    required this.publicoAlvo,
    required this.tema,
    required this.codigoIbge,
    required this.gentilico,
    required this.ibge,
    required this.historicoEleicoes,
    required this.regrasProbabilidade,
    required this.contabilidade,
    required this.calendarioMef,
    required this.feriadosMunicipais,
    required this.politicasPublicas,
    required this.marketingFalas,
    required this.termosCorretor,
    required this.faq,
  });

  factory DadosEstacaoModel.fromJson(Map<String, dynamic> json) {
    return DadosEstacaoModel(
      municipio: json['municipio']?.toString() ?? 'Estação',
      uf: json['uf']?.toString() ?? 'RS',
      publicoAlvo: json['publico_alvo']?.toString() ?? 'Candidatos',
      tema: json['tema']?.toString() ?? 'Consultoria Política',
      codigoIbge: json['codigo_ibge'] is int ? json['codigo_ibge'] : 4307559,
      gentilico: json['gentilico']?.toString() ?? 'estacionense',
      ibge: DadosIbge.fromJson(
        json['ibge'] is Map<String, dynamic> ? json['ibge'] : {},
      ),
      historicoEleicoes: ((json['historico_eleicoes'] as List?) ?? [])
          .map((e) => HistoricoEleicao.fromJson(e as Map<String, dynamic>))
          .toList(),
      regrasProbabilidade: RegrasProbabilidade.fromJson(
        json['regras_probabilidade'] is Map<String, dynamic>
            ? json['regras_probabilidade']
            : {},
      ),
      contabilidade: ContabilidadeCalculadora.fromJson(
        json['contabilidade_calculadora'] is Map<String, dynamic>
            ? json['contabilidade_calculadora']
            : {},
      ),
      calendarioMef: ((json['calendario_eleitoral_mef'] as List?) ?? [])
          .map((c) => EtapaCalendario.fromJson(c as Map<String, dynamic>))
          .toList(),
      feriadosMunicipais: ((json['feriados_municipais'] as List?) ?? [])
          .map((f) => FeriadoMunicipal.fromJson(f as Map<String, dynamic>))
          .toList(),
      politicasPublicas: ((json['leis_e_politicas_publicas'] as List?) ??
          (json['pautas_prioritarias'] as List?) ??
          [])
          .map((p) => PoliticaPublica.fromJson(p as Map<String, dynamic>))
          .toList(),
      marketingFalas: ((json['marketing_e_falas'] as List?) ?? [])
          .map((m) => RoteiroMarketing.fromJson(m as Map<String, dynamic>))
          .toList(),
      termosCorretor: ((json['corretor_ortografico_termos'] as List?) ?? [])
          .map((t) => TermoCorretor.fromJson(t as Map<String, dynamic>))
          .toList(),
      faq: ((json['faq'] as List?) ?? [])
          .map((fq) => ItemFaq.fromJson(fq as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DadosIbge {
  final int populacaoCenso2022;
  final int populacaoEstimada2026;
  final double areaTerritorialKm2;
  final double densidadeDemografica;
  final double escolarizacao;
  final double idhm;
  final double pibPerCapita;
  final double receitasBrutas;
  final double despesasBrutas;
  final int vagasCamara;

  DadosIbge({
    required this.populacaoCenso2022,
    required this.populacaoEstimada2026,
    required this.areaTerritorialKm2,
    required this.densidadeDemografica,
    required this.escolarizacao,
    required this.idhm,
    required this.pibPerCapita,
    required this.receitasBrutas,
    required this.despesasBrutas,
    required this.vagasCamara,
  });

  factory DadosIbge.fromJson(Map<String, dynamic> json) {
    return DadosIbge(
      populacaoCenso2022: (json['populacao_censo_2022'] as num?)?.toInt() ?? 5582,
      populacaoEstimada2026: (json['populacao_estimada_2026'] as num?)?.toInt() ?? 5685,
      areaTerritorialKm2: (json['area_territorial_km2'] as num?)?.toDouble() ?? 99.757,
      densidadeDemografica: (json['densidade_demografica'] as num?)?.toDouble() ?? 55.96,
      escolarizacao: (json['escolarizacao_6_a_14'] as num?)?.toDouble() ?? 100.0,
      idhm: (json['idhm'] as num?)?.toDouble() ?? 0.753,
      pibPerCapita: (json['pib_per_capita'] as num?)?.toDouble() ?? 71277.75,
      receitasBrutas: (json['receitas_brutas'] as num?)?.toDouble() ?? 64078542.86,
      despesasBrutas: (json['despesas_brutas'] as num?)?.toDouble() ?? 52814487.03,
      vagasCamara: (json['vagas_camara'] as num?)?.toInt() ?? 9,
    );
  }
}

class HistoricoEleicao {
  final int ano;
  final int eleitoradoTotal;
  final int votosValidos;
  final int quocienteEleitoral;
  final int clausulaBarreira10;

  HistoricoEleicao({
    required this.ano,
    required this.eleitoradoTotal,
    required this.votosValidos,
    required this.quocienteEleitoral,
    required this.clausulaBarreira10,
  });

  factory HistoricoEleicao.fromJson(Map<String, dynamic> json) {
    return HistoricoEleicao(
      ano: (json['ano'] as num?)?.toInt() ?? 0,
      eleitoradoTotal: (json['eleitorado_total'] as num?)?.toInt() ?? 0,
      votosValidos: (json['votos_validos'] as num?)?.toInt() ?? 0,
      quocienteEleitoral: (json['quociente_eleitoral'] as num?)?.toInt() ?? 0,
      clausulaBarreira10: (json['clausula_barreira_10'] as num?)?.toInt() ?? 0,
    );
  }
}

class RegrasProbabilidade {
  final String criterioCorte;
  final List<dynamic> faixasProbabilidade;

  RegrasProbabilidade({
    required this.criterioCorte,
    required this.faixasProbabilidade,
  });

  factory RegrasProbabilidade.fromJson(Map<String, dynamic> json) {
    return RegrasProbabilidade(
      criterioCorte: json['criterio_corte']?.toString() ?? '10% do QE',
      faixasProbabilidade: ((json['faixas_probabilidade'] as List?) ?? []),
    );
  }
}

class ContabilidadeCalculadora {
  final double tetoVereador;
  final double tetoPrefeito;
  final List<dynamic> divisaoSugerida;

  ContabilidadeCalculadora({
    required this.tetoVereador,
    required this.tetoPrefeito,
    required this.divisaoSugerida,
  });

  factory ContabilidadeCalculadora.fromJson(Map<String, dynamic> json) {
    return ContabilidadeCalculadora(
      tetoVereador: (json['teto_gastos_vereador_referencia'] as num?)?.toDouble() ?? 15998.00,
      tetoPrefeito: (json['teto_gastos_prefeito_referencia'] as num?)?.toDouble() ?? 159980.00,
      divisaoSugerida: ((json['divisao_sugerida_percentual'] as List?) ?? []),
    );
  }
}

class EtapaCalendario {
  final String etapa;
  final String prazo;
  final String descricao;

  EtapaCalendario({
    required this.etapa,
    required this.prazo,
    required this.descricao,
  });

  factory EtapaCalendario.fromJson(Map<String, dynamic> json) {
    return EtapaCalendario(
      etapa: json['etapa']?.toString() ?? '',
      prazo: json['prazo']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
    );
  }
}

class FeriadoMunicipal {
  final String data;
  final String nome;

  FeriadoMunicipal({required this.data, required this.nome});

  factory FeriadoMunicipal.fromJson(Map<String, dynamic> json) {
    return FeriadoMunicipal(
      data: json['data']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
    );
  }
}

class PoliticaPublica {
  final String eixo;
  final String secretaria;
  final String politica;

  PoliticaPublica({
    required this.eixo,
    required this.secretaria,
    required this.politica,
  });

  factory PoliticaPublica.fromJson(Map<String, dynamic> json) {
    return PoliticaPublica(
      eixo: json['eixo']?.toString() ?? json['area']?.toString() ?? '',
      secretaria: json['secretaria']?.toString() ?? 'Geral',
      politica: json['politica']?.toString() ?? json['proposta']?.toString() ?? '',
    );
  }
}

class RoteiroMarketing {
  final String tema;
  final String roteiroSugerido;

  RoteiroMarketing({required this.tema, required this.roteiroSugerido});

  factory RoteiroMarketing.fromJson(Map<String, dynamic> json) {
    return RoteiroMarketing(
      tema: json['tema']?.toString() ?? '',
      roteiroSugerido: json['roteiro_sugerido']?.toString() ?? '',
    );
  }
}

class TermoCorretor {
  final String termo;
  final String status;
  final String correcao;

  TermoCorretor({
    required this.termo,
    required this.status,
    required this.correcao,
  });

  factory TermoCorretor.fromJson(Map<String, dynamic> json) {
    return TermoCorretor(
      termo: json['termo']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      correcao: json['correcao']?.toString() ?? '',
    );
  }
}

class ItemFaq {
  final String pergunta;
  final String resposta;

  ItemFaq({required this.pergunta, required this.resposta});

  factory ItemFaq.fromJson(Map<String, dynamic> json) {
    return ItemFaq(
      pergunta: json['pergunta']?.toString() ?? '',
      resposta: json['resposta']?.toString() ?? '',
    );
  }
}