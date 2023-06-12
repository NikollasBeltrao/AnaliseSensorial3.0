import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NativePageTransitions, NativeTransitionOptions } from '@ionic-native/native-page-transitions/ngx';
import { AlertController, LoadingController, Platform } from '@ionic/angular';
import { Usuario } from 'src/modal/usuario';
import { UsuarioService } from 'src/services/usuario.service';

@Component({
  selector: 'app-usuario-logado',
  templateUrl: './usuario-logado.page.html',
  styleUrls: ['./usuario-logado.page.scss'],
})
export class UsuarioLogadoPage implements OnInit {
  usuario: Usuario;
  backButtonSubscription;
  bgs = ['bg-azul', 'bg-laranja', 'bg-rosa', 'bg-amarelo'];
  constructor(public route: Router, public active: ActivatedRoute, private http: HttpClient, public loading: LoadingController,
    private usuarioService: UsuarioService, public alertController: AlertController, private platform: Platform,
    private nativePageTransitions: NativePageTransitions) {
    this.usuario = new Usuario();
  }

  ionViewDidEnter() {
    this.backButtonSubscription = this.platform.backButton.subscribe(() => {
      let options: NativeTransitionOptions = {
        direction: 'right',
        duration: 400,
      }
      this.nativePageTransitions.slide(options)
        .catch(console.error);
      this.route.navigate(['login']);
    });
  }
  ionViewDidLeave() {
    this.backButtonSubscription.unsubscribe();
  }
  async ngOnInit() {
    let load = await this.loading.create({
      message: 'Carregando',

    });
    load.present();
    await this.active.params.subscribe(async parms => {
      await this.usuarioService.getById(parms["id_usuario"]).
        then(response => {
          this.usuario = response;          
          load.dismiss();
        }, (err) => {
          load.dismiss();
          this.presentAlert("Erro ao carregar os dados");
        });
    });
  }
  bg(i) {
    if (i >= this.bgs.length) {
      return i % this.bgs.length;
    }
    return i;
  }

  nextPage() {
    let options: NativeTransitionOptions = {
      direction: 'left',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
  }

  listarUsuarios() {
    this.backButtonSubscription.unsubscribe();
    this.nextPage();
    this.route.navigate(["listar-usuarios", { id_usuario: this.usuario.id_usuario }]);
  }

  listarAnalises() {
    this.backButtonSubscription.unsubscribe();
    this.nextPage();
    this.route.navigate(["listar-analises", { id_usuario: this.usuario.id_usuario }]);

  }
  cadastrarAnalise() {
    this.backButtonSubscription.unsubscribe();
    this.nextPage();
    this.route.navigate(["criar-analise", { id_usuario: this.usuario.id_usuario }]);
  }
  cadastrarUsuario() {
    this.backButtonSubscription.unsubscribe();
    this.nextPage();
    this.route.navigate(["criar-usuario", { id_usuario: this.usuario.id_usuario, tipo_user: 2 }]);
  }
  sair() {
    this.backButtonSubscription.unsubscribe();
    let options: NativeTransitionOptions = {
      direction: 'right',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
    this.route.navigate(["home"]);
  }
  goPerfil() {
    this.backButtonSubscription.unsubscribe();
    this.nextPage();
    this.route.navigate(["perfil", { id_usuario: this.usuario.id_usuario }]);
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
}
