import { Atributo } from "./atributo";
import { Ficha } from "./ficha";

export class AnaliseTeste {
    id_analise_teste: number;
    descricao_analise_teste: string;
    descricao_teste: string;
    fk_teste_padrao: number;
    nome_teste: string;
    ordem: number;
    fichas: Array<Ficha>;
    atributos: Array<Atributo>;
}