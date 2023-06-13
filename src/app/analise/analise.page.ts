import { stringify } from '@angular/compiler/src/util';
import { AlertController, ToastController } from '@ionic/angular';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LoadingController, NavController } from '@ionic/angular';
import { AnaliseService } from 'src/services/analise.service';
import { NativePageTransitions, NativeTransitionOptions } from '@ionic-native/native-page-transitions/ngx';
import { isEmptyObject } from 'jquery';
import { Analise } from 'src/modal/analise';
import { Amostra } from 'src/modal/amostra';
import { Ficha } from 'src/modal/ficha';
import { Resposta } from 'src/modal/resposta';
import { AnaliseTeste } from 'src/modal/analise_teste';
@Component({
  selector: 'app-analise',
  templateUrl: './analise.page.html',
  styleUrls: ['./analise.page.scss'],
})
export class AnalisePage implements OnInit {
  passos = {
    id: 0,
    err: ''
  };
  codigo_analise = '';
  analise: Analise;
  amostras: Array<Amostra>;
  ficha: Ficha;
  respostas: Array<Resposta>;
  testeIsolado: Array<AnaliseTeste> = [];

  allAnalises: Array<any>;


  escalas: Array<any>
  escolherAnalise = true;
  instrucoes = false;
  bgs = ['bg-azul', 'bg-laranja', 'bg-rosa', 'bg-amarelo'];
  a;
  constructor(private analiseService: AnaliseService, public loading: LoadingController, private router: Router,
    public alertController: AlertController, private nativePageTransitions: NativePageTransitions,
    public toastController: ToastController) {
    this.analise = new Analise;
    this.amostras = [];
    this.ficha = new Ficha;
    this.ficha.faixa_etaria = '';
    this.ficha.genero = '';
    this.ficha.frequencia_consumo = 0;
  }

  ngOnInit() {

  }
  getByCode(e) {
    if (this.codigo_analise.length == 6) {
      this.getAnalise(e);
    }
  }

  async getAnalise(e) {
    let options: NativeTransitionOptions = {
      direction: 'left',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
    let load = await this.loading.create({
      message: 'Carregando',
    });
    load.present();
    await this.analiseService.getAnaliseByCodigo(this.codigo_analise).then(data => {
      if (data) {
        this.analise = data;
        this.instrucoes = true;
        this.escolherAnalise = false;
      }
      else {
        e.target.className = "form-control is-invalid";
      }
      load.dismiss();
    }, (err) => {
      this.presentToast("Ocorreu um erro ao carregar os dados");
    });

    await this.analiseService.getRespostaByCodigo(this.codigo_analise).then(data => {
      this.amostras = data;
      console.log(this.amostras);
      data[0]?.analise_teste.forEach(teste => {
        if (teste.id_teste_padrao == 3 || teste.id_teste_padrao == 4) {
          this.testeIsolado.push(teste);
        }
      });
      load.dismiss();
    }, (err) => {
      console.log(err);
      this.presentToast("Ocorreu um erro ao carregar os dados");
    });
  }


  proximo(id: number, amostra?: number) {
    switch (id) {
      case -2:
        var cont = 0;
        this.testeIsolado[amostra-1].atributos.forEach((re) => {
          if (re.valor == 0) {
            cont += 1;
          }
        });
        if (cont == 0) {
          //this.submit();
        }
        else {
          this.presentToast('Preencha todos os campos');
        }
        break;
      case -1:
        var cont = 0;
        this.amostras[amostra].analise_teste.forEach((am) => {
          am.atributos.forEach((re) => {
            if (re.valor == 0 && am.fk_teste_padrao < 3) {
              cont += 1;
            }
          });
        });
        if (cont == 0) {
          //this.submit();
        }
        else {
          this.presentToast('Preencha todos os campos');
        }
        break;
      case 1:
        if (this.ficha.faixa_etaria != '' && this.ficha.genero != '' && this.ficha.frequencia_consumo != 0) {
          this.passos = { ...this.passos, id: id };
        }
        else {
          this.presentToast('Preencha todos os campos');
        }
        break;
      default:
        var cont = 0;
        if (id > this.amostras.length + 1) {
          this.testeIsolado[amostra].atributos.forEach((re) => {
            if (re.valor == 0) {
              cont += 1;
            }
          });
        }
        else {
          this.amostras[amostra].analise_teste.forEach((am) => {
            am.atributos.forEach((re) => {
              if (re.valor == 0 && am.fk_teste_padrao < 3) {
                cont += 1;
              }
            });
          });
        }

        if (cont == 0) {
          this.passos = { ...this.passos, id: id };
        }
        else {
          this.presentToast('Preencha todos os campos');
        }
    }
  }

  anterior(id: number) {
    this.passos = { ...this.passos, id: id };
  }

  async presentAlert(message, finalizar?) {
    const alert = await this.alertController.create({
      cssClass: 'alerta',
      header: (finalizar ? finalizar : "Erro"),
      message: message,
      buttons: [
        {
          text: 'Ok',
          cssClass: 'alertBtn',
          handler: () => {
            console.log('ok');
          }
        }
      ],
    });
    await alert.present();
  }
  sair() {
    if (this.escolherAnalise) {
      this.goHome();
    }
    let options: NativeTransitionOptions = {
      duration: 400,
    }
    this.nativePageTransitions.fade(options)
      .catch(console.error);
    this.escolherAnalise = true;
    this.instrucoes = false;
    this.passos = {
      id: 0,
      err: ''
    }
    this.analise = new Analise;
    this.allAnalises = [];
    this.amostras = [];
    this.escalas = [];
    this.respostas = [];
  }


  async submit() {
    let load = await this.loading.create({
      message: 'Carregando',
    });
    load.present();
    let form = new FormData();
    form.append("saveRespostas", (JSON.stringify(this.respostas[0])));
    await this.analiseService.saveRespostas(form).then(res => {
      load.dismiss();
      this.presentAlert("Obrigado por participar da pesquisa !!! 😉", ' ');
      this.sair();
    }, (err) => {
      load.dismiss();
      this.presentToast("Ocorreu um erro ao salvar os dados");
      console.log(err)
    });
  }

  async presentToast(menssagem: string) {
    const toast = await this.toastController.create({
      message: menssagem,
      duration: 2000,
      color: "danger"
    });
    toast.present();
  }

  bg(i) {
    if (i >= this.bgs.length) {
      return i % this.bgs.length;
    }
    return i;
  }

  goHome() {
    let options: NativeTransitionOptions = {
      direction: 'right',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
    this.escolherAnalise = false;
    this.sair();
    this.router.navigate(['home']);
  }
}
