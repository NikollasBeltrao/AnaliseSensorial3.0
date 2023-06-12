import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NativePageTransitions, NativeTransitionOptions } from '@ionic-native/native-page-transitions/ngx';
import { ActionSheetController, AlertController, LoadingController } from '@ionic/angular';
import { Analise } from 'src/modal/analise';
import { AnaliseService } from 'src/services/analise.service';

@Component({
  selector: 'app-listar-analises',
  templateUrl: './listar-analises.page.html',
  styleUrls: ['./listar-analises.page.scss'],
})
export class ListarAnalisesPage implements OnInit {
  analises: Array<Analise>;
  goToResposta = true;
  idUser = '';
  bgs = ['bg-azul', 'bg-laranja', 'bg-rosa', 'bg-amarelo'];
  constructor(private analiseService: AnaliseService, private route: Router, private active: ActivatedRoute,
    public loading: LoadingController, public alertController: AlertController,
    private nativePageTransitions: NativePageTransitions,
    public actionSheetController: ActionSheetController) { }

  async ngOnInit() {
    this.load();
    await this.active.params.subscribe(params => {
      this.idUser = params["id_usuario"];
    });
  }

  async load() {
    let load = await this.loading.create({
      message: 'Carregando',
    });
    load.present();
    await this.analiseService.getByUsuario(this.idUser).then(data => {
      if (data) {
        this.analises = data;
        load.dismiss();
      }
    }, err => {
      load.dismiss();
      this.presentAlert("Erro ao carregar os dados");
    });
  }

  converterData(data) {
    return new Date(data.replace('-', '/')).toLocaleDateString();
  }

  doRefresh(event) {
    setTimeout(async () => {
      await this.load();
      event.target.complete();
    }, 2000);
  }
  goToRespostas(id) {
    this.nextPage();
    this.route.navigate(['listar-respostas', { id: id, id_user: this.idUser }]);
  }
  async switch(e, id) {
    let load = await this.loading.create({
      message: 'Carregando',
    });
    load.present();
    var novoStatus = (e.target.checked ? 0 : 1);
    var form = new FormData();
    form.append("id", id);
    form.append("novoStatus", novoStatus.toString());
    console.log(novoStatus);
    await this.analiseService.changeStatus(form).then(res => {
      if (res) {
        e.target.checked = novoStatus;
      }
      load.dismiss();
    }, err => {
      load.dismiss();
      this.presentAlert("Erro ao alterar o status");
    });

  }

  goHome() {
    this.back();
    this.route.navigate(["usuario-logado", { id_user: this.idUser }]);
  }
  goPerfil() {
    this.nextPage();
    this.route.navigate(["perfil", { id_user: this.idUser }]);
  }
  sair() {
    this.back();
    this.route.navigate(["home"]);
  }
  async presentAlert(message) {
    const alert = await this.alertController.create({
      cssClass: 'alerta',
      header: "Erro",
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
  bg(i) {
    if (i >= this.bgs.length) {
      return i % this.bgs.length;
    }
    return i;
  }


  async presentActionSheet(analise: Analise) {
    const actionSheet = await this.actionSheetController.create({
      header: analise.nome_alimento,
      buttons: [
        {
          text: 'Respostas',
          icon: 'bar-chart-outline',
          handler: () => {
            this.goToRespostas(analise.id_analise);
          },
        },
        {
          cssClass: 'err',
          text: 'Remover',
          role: 'destructive',
          icon: 'trash',
          handler: () => {
            console.log('Delete clicked');
          },
        },
        {          
          text: 'Sair',
          icon: 'close',
          role: 'cancel',
          handler: () => {
            actionSheet.dismiss();
          },
        }
      ],
    });
    await actionSheet.present();

  }
}
