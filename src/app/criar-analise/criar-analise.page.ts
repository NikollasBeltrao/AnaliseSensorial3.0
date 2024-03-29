import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { NativePageTransitions, NativeTransitionOptions } from '@ionic-native/native-page-transitions/ngx';
import { AlertController, LoadingController } from '@ionic/angular';
import { Atributo } from 'src/modal/atributo';
import { AnaliseService } from 'src/services/analise.service';

@Component({
  selector: 'app-criar-analise',
  templateUrl: './criar-analise.page.html',
  styleUrls: ['./criar-analise.page.scss'],
})
export class CriarAnalisePage implements OnInit {
  fGroup: FormGroup;
  atributos: Array<Atributo>;

  foto = "";
  fotos = [];
  err = "";
  validar = false;
  idUser;
  a = "https://mdbootstrap.com/img/Photos/Others/placeholder.jpg";
  constructor(private analiseService: AnaliseService, private active: ActivatedRoute,
    private loadingCtrl: LoadingController, public formBuilder: FormBuilder, private router: Router,
    private nativePageTransitions: NativePageTransitions, public alertController: AlertController) {
    this.fGroup = this.formBuilder.group({
      nome_alimento: new FormControl('', Validators.required),
      hedonica: new FormControl(''),
      compra: new FormControl(''),
      preferencia: new FormControl(''),
      comparacao: new FormControl(''),
      instrucoes: new FormControl(''),
      atributosHedonica: new FormControl([]),
      atributosCompra: new FormControl([]),
      aux_atributos: new FormControl(0),
      atributosPreferencia: new FormControl([]),
      atributosComparacao: new FormControl([]),
      aux_atributos_comparacao: new FormControl(0),
      descCompra: new FormControl('Agora avalie quanto à sua atitude de compra'),
      descHedonica: new FormControl('Você está recebendo ---- amostras de -----. Avalie cada amostra e utilize a escala abaixo para identificar o quanto você gostou/desgostou ' +
        'de cada amostra quanto à ----, ----, ----, ---- e ----. Prove as amostras da esquerda para direita.'),
      descPreferencia: new FormControl('Você está recebendo ---- amostras de -----. Por favor, prove as amostras da esquerda para direita e selecione a mais -----.'),
      descComparacao: new FormControl('Você está recebendo ---- amostras de -----. Por favor, prove as amostras da esquerda para direita e selecione a mais -----.'),
    });
    this.atributos = [];
  }

  async ngOnInit() {
    await this.active.params.subscribe(params => {
      this.idUser = params["id_usuario"];
    });
    this.listarAtributos();
  }

  async listarAtributos() {
    let load = await this.loadingCtrl.create({
      message: 'Carregando',
    });
    load.present();
    await this.analiseService.listarAtributos().then(data => {
      if (data) {
        this.atributos = data;
      }
      load.dismiss();
    }, err => {
      load.dismiss();
    });
  }

  salvar_atributo_hedonica() {
    let aux = parseInt(this.fGroup.value.aux_atributos);
    this.fGroup.value.atributosHedonica.push({
      display: this.atributos[aux].nome_atributo,
      value: this.atributos[aux].id_atributo_padrao
    });
  }

  removerAtributoHed(indice) {
    this.fGroup.value.atributosHedonica.splice(indice, 1);
  }

  removerAtributoComp(indice) {
    this.fGroup.value.atributosComparacao.splice(indice, 1);
  }

  alterar_atributos_comparacao() {
    let aux = parseInt(this.fGroup.value.aux_atributos_comparacao);
    this.fGroup.value.atributosComparacao.push({
      display: this.atributos[aux].nome_atributo,
      value: this.atributos[aux].id_atributo_padrao
    });

  }

  upload() {
    //console.log(form.tags);
    //form.tags = this.tagArrayToString(form.tags);
    this.fGroup.value.tags[0].value = 1;
  }

  tagArrayToString(tagArray: string[]): any {
    if (Array.isArray(tagArray) && tagArray.length > 0) {
      return tagArray;
    } else {
      return [];
    }
  }


  async cadastrar() {
    let load = await this.loadingCtrl.create({
      message: 'Carregando',
    });
    load.present();
    this.validar = true;
    if (this.fGroup.valid &&
      ((this.fGroup.value.hedonica && this.fGroup.value.descHedonica != '' && this.fGroup.controls.atributosHedonica.value.length > 0)
        || (this.fGroup.value.compra && this.fGroup.value.descCompra != '') ||
        (this.fGroup.value.preferencia && this.fGroup.value.descPreferencia != '') ||
        (this.fGroup.value.comparacao && this.fGroup.value.descComparacao != '' && this.fGroup.controls.atributosComparacao.value.length > 0))) {

      var analise_testes = [];

      if (this.fGroup.value.hedonica) {
        analise_testes.push({
          fk_teste_padrao: 1,
          descricao: this.fGroup.value.descHedonica,
          atributos: this.fGroup.value.atributosHedonica
        })
      }

      if (this.fGroup.value.compra) {
        analise_testes.push({
          fk_teste_padrao: 2,
          descricao: this.fGroup.value.descCompra,
          atributos: [{ display: '', value: '1' }]
        })
      }

      if (this.fGroup.value.preferencia) {
        analise_testes.push({
          fk_teste_padrao: 3,
          descricao: this.fGroup.value.descPreferencia,
          atributos: [{ display: '', value: '5' }]
        })
      }

      if (this.fGroup.value.comparacao) {
        analise_testes.push({
          fk_teste_padrao: 4,
          descricao: this.fGroup.value.descComparacao,
          atributos: this.fGroup.value.atributosComparacao
        })
      }
      let idAnalise;

      console.log(analise_testes);

      let form = new FormData();
      form.append("nome_alimento", this.fGroup.value.nome_alimento);
      form.append("fk_usuario", this.idUser);
      form.append("instrucoes", this.fGroup.value.instrucoes);
      form.append("analise_testes", JSON.stringify(analise_testes));

      await this.analiseService.cadastrarAnalise(form).then(res => {
        let response = (res["id_analise"]);
        if (response) {
          load.dismiss();
          this.presentAlert(response);
          idAnalise = response;
        }
        load.dismiss();
      }).catch(err => {
        load.dismiss();
        console.error(err);
      });


    }
    else {
      this.err = "Peencha todos os campos";
      load.dismiss();
    }
  }
  goHome() {
    this.back();
    this.router.navigate(["usuario-logado", { id_user: this.idUser }]);
  }
  sair() {
    this.back();
    this.router.navigate(["home"]);
  }
  goPerfil() {
    this.nextPage();
    this.router.navigate(["perfil", { id_user: this.idUser }]);
  }

  nextPage() {
    let options: NativeTransitionOptions = {
      direction: 'left',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
  }
  back() {
    let options: NativeTransitionOptions = {
      direction: 'right',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
  }
  async presentAlert(idAnalise) {
    const alert = await this.alertController.create({
      cssClass: 'alerta',
      header: "Sucesso",
      message: "Você será redirecionado para a página de cadastro de amostras",
      buttons: [
        {
          text: 'Ok',
          cssClass: 'alertBtn',
          handler: () => {
            this.nextPage();
            this.router.navigate(["cadastrar-amostra", { id_user: this.idUser, id_analise: idAnalise }]);
          }
        }
      ],
    });
    await alert.present();
  }
}
