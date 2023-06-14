import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AnaliseService } from 'src/services/analise.service';
import { PhotoViewer } from '@ionic-native/photo-viewer/ngx';
import { AlertController, LoadingController, NavController } from '@ionic/angular';
import { NativePageTransitions, NativeTransitionOptions } from '@ionic-native/native-page-transitions/ngx';
import { Chart, registerables } from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import { Analise } from 'src/modal/analise';
import { Amostra } from 'src/modal/amostra';
import { AnaliseTeste } from 'src/modal/analise_teste';

@Component({
  selector: 'app-listar-respostas',
  templateUrl: './listar-respostas.page.html',
  styleUrls: ['./listar-respostas.page.scss'],
})
export class ListarRespostasPage implements OnInit {
  analise: Analise;
  amostras: Array<Amostra>;
  testesIsolados: Array<AnaliseTeste>;
  constructor(private analiseService: AnaliseService, private active: ActivatedRoute, private route: Router,
    private photoViewer: PhotoViewer, public loading: LoadingController, public alertController: AlertController,
    private navCtrl: NavController, private nativePageTransitions: NativePageTransitions) {
    Chart.register(...registerables);
    this.amostras = [];
    this.testesIsolados = [];
    this.analise = new Analise();
  }
  barchar: any;
  barchar2: any;
  piechar: any;
  idUser = '';
  err = "";
  bgs = ['bg-azul', 'bg-laranja', 'bg-rosa', 'bg-amarelo'];
  segment = 0;
  ngOnInit() {
    this.carregarRespostas();
  }

  segmentChanged(e) {
    const div = <HTMLElement>document.getElementById("graficos");
    div.innerHTML = '';
    if (this.segment == 1) {
      this.listarGraficos();
    }
  }
  async carregarRespostas() {
    let load = await this.loading.create({
      message: 'Carregando',
    });
    load.present();
    await this.active.params.subscribe(async params => {
      this.idUser = params['id_user'];
      await this.analiseService.getAnaliseById(params['id']).then(data => {
        this.analise = data;
      }, err => {
        console.log(err)
        this.presentAlert("Erro ao carregar os dados");
        this.navCtrl.back();
      })

      await this.analiseService.listarResultados(params['id']).then(data => {
        this.amostras = data[0];
        this.testesIsolados = data[1];
      }, err => {
        this.presentAlert("Erro ao carregar os dados");
        this.navCtrl.back();
      })
    });
    load.dismiss();
  }


  async listarGraficos() {
    const div = <HTMLElement>document.getElementById("graficos");
    div.innerHTML = '';
    let load = await this.loading.create({
      message: 'Carregando',
    });
    load.present();
    await this.active.params.subscribe(async params => {
      this.idUser = params['id_user'];
      await this.analiseService.listarGraficos(params['id']).then(data => {
        console.log(data)
        data.forEach((teste) => {
          teste.atributos.forEach((atributo) => {

            if (atributo.amostras) {
              atributo.amostras.forEach((amostra) => {
                var dataHed = [0, 0, 0, 0, 0, 0, 0, 0, 0];
                var dataCom = [0, 0, 0, 0, 0];
                var dataGrafico = [];
                amostra.respostas.forEach((res) => {
                  if (teste.nome_teste == "Escala Hedônica") {
                    dataHed[parseInt(res.resposta) - 1] = parseInt(res.count);
                    dataGrafico = dataHed;
                  }
                  else if (teste.nome_teste == "Atitude de Compra") {
                    dataCom[parseInt(res.resposta) - 1] = parseInt(res.count);
                    dataGrafico = dataCom;
                  }
                })

                this.gerarGrafico(teste.nome_teste,
                  dataGrafico,
                  (teste.nome_teste + " - Amos: " + amostra.numero_amostra + " - Atr: " + atributo.nome_atributo),
                  this.bgs[0])
              })
            }
            else {
              var dataGrafico = [];
              var dataLabel = [];
              atributo.respostas.forEach((res) => {
                dataGrafico.push(parseInt(res.count));
                dataLabel.push(res.resposta);              
              })

              this.gerarGrafico(teste.nome_teste,
                dataGrafico,
                (teste.nome_teste + " - Atr: " + atributo.nome_atributo),
                this.bgs[1], dataLabel)
            }
          })
        })
      }, err => {
        console.log(err)
        this.presentAlert("Erro ao carregar os dados");
        this.navCtrl.back();
      })
    });
    load.dismiss();
  }

  imgFull(img) {
    this.photoViewer.show(img);
  }
  //ngAfterViewInit
  ngAfterViewIni() {

  }

  doRefresh(event) {
    setTimeout(() => {
      if (this.segment == 1) {
        this.listarGraficos();
      }
      else {
        this.carregarRespostas();
      }
      event.target.complete();
    }, 2000);
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
  bg(i) {
    if (i >= this.bgs.length) {
      return i % this.bgs.length;
    }
    return i;
  }
  gerarGrafico(teste, data, title, cor, pref?) {
    const div = <HTMLElement>document.getElementById("graficos");
    const div2 = <HTMLElement>document.createElement("div");
    const ctx = <HTMLCanvasElement>document.createElement("canvas");
    const h2 = <HTMLElement>document.createElement("div");
    h2.innerHTML = title;
    h2.className = "h2_graficos " + cor;
    h2.style.padding = '10px';
    h2.style.textAlign = 'center';
    h2.style.fontSize = '18px';
    h2.style.fontWeight = 'bold';
    h2.style.border = 'solid 1px gray';
    h2.style.borderBottom = 'none';
    div2.style.margin = "20px";
    div2.style.width = "90%";
    div2.style.maxWidth = "600px";
    div2.appendChild(h2);
    ctx.height = 400;
    ctx.width = 400;
    ctx.style.border = 'solid 1px gray';
    ctx.style.boxShadow = "0px 1px 7px rgba(0, 0, 0, 0.45)";

    Chart.register(ChartDataLabels);


    const myChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: (teste == "Escala Hedônica" ? ["Desgostei muitíssimo", "Desgostei muito", "Desgostei moderadamente", "Desgostei ligeiramente", "Nem gostei / nem desgostei",
          "Gostei ligeiramente", "Gostei moderadamente", "Gostei muito", "Gostei muitíssimo"] :
          teste == "Atitude de Compra" ? ["Certamente não compraria", "Provavelmente não compraria", "Tenho dúvida se compraria",
            "Provavelmente compraria", "Certamente compraria"] : pref),
        datasets: [{
          label: 'title',
          hoverOffset: 10,
          weight: 700,
          data: data,
          borderJoinStyle: 'bevel',
          backgroundColor: [
            'rgb(161, 159, 165)',
            'rgb(242, 232, 218)',
            'rgb(245, 198, 200)',
            'rgb(168, 147, 192)',
            'rgb(186, 153, 114)',
            'rgb(248, 233, 154)',
            'rgb(136, 129, 164)',
            'rgb(162, 184, 212)',
            'rgb(250, 158, 147)',
            'rgb(174, 84, 89)',
          ],
          borderColor: [
            'white',
          ],
          borderWidth: 1
        }]
      },
      options: {
        animation: {
          animateScale: true,
        },
        spacing: 2,
        cutout: 50,
        plugins: {
          datalabels: {
            formatter: (value, ctx) => {

              let sum = 0;
              let dataArr = ctx.chart.data.datasets[0].data;
              dataArr.map((data: number) => {
                sum = sum + data;
              });
              let percentage = (value * 100 / sum).toFixed(1);
              return value > 0 ? percentage + "%" : '';


            },
            color: 'rgb(0, 0, 0)',
          }
        }
      },
    });
    div2.appendChild(ctx);
    div.appendChild(div2);
  }
}
