import { CompositionRoot } from '../../composition/CompositionRoot';
import { AddServerResult, ServerConnectionResult, ServerConnectionState } from '../../domain/server/ServerConnection';
import { ServerProfile } from '../../domain/model/UserModels';

@Component
export struct MyTab {
  @State name: string = '';
  @State url: string = '';
  @State username: string = '';
  @State password: string = '';
  @State status: string = '';
  @State busy: boolean = false;
  @State savedSummary: string = '（无已保存服务器）';
  @State savedServerId: string = '';
  @State hasSavedCredential: boolean = false;

  aboutToAppear(): void {
    this.loadSaved();
  }

  private stateLabel(state: ServerConnectionState): string {
    if (state === 'CONNECTED') {
      return '连接成功';
    }
    if (state === 'AUTH_FAILED') {
      return '认证失败';
    }
    if (state === 'NETWORK_ERROR') {
      return '网络错误';
    }
    if (state === 'TIMEOUT') {
      return '连接超时';
    }
    if (state === 'SERVER_ERROR') {
      return '服务器错误';
    }
    if (state === 'INVALID_RESPONSE') {
      return '协议/响应错误';
    }
    return '连接中...';
  }

  async loadSaved(): Promise<void> {
    try {
      const servers: ServerProfile[] = await CompositionRoot.get().serverConnectionFlow.listServers();
      if (servers.length > 0) {
        const s: ServerProfile = servers[0];
        this.name = s.name;
        this.url = s.primaryUrl;
        this.username = s.username === undefined ? '' : s.username;
        this.savedServerId = s.id;
        this.hasSavedCredential = await CompositionRoot.get().serverConnectionFlow.hasCredential(s);
        this.savedSummary = '已保存: ' + s.name + ' (' + s.primaryUrl + ')' +
          (this.hasSavedCredential ? ' · 凭据已保存' : ' · 凭据缺失');
      } else {
        this.savedServerId = '';
        this.hasSavedCredential = false;
        this.savedSummary = '（无已保存服务器）';
      }
    } catch (e) {
      this.savedSummary = '（读取失败）';
    }
  }

  async reconnect(): Promise<void> {
    if (this.busy || this.savedServerId === '' || !this.hasSavedCredential) {
      return;
    }
    this.busy = true;
    this.status = this.stateLabel('CONNECTING');
    try {
      const result: ServerConnectionResult = await CompositionRoot.get().serverConnectionFlow.reconnectServer(this.savedServerId);
      if (result.state === 'CONNECTED') {
        this.status = '连接成功 — ' + (result.serverType === undefined ? '' : result.serverType) +
          (result.serverVersion === undefined ? '' : ' ' + result.serverVersion);
      } else {
        this.status = this.stateLabel(result.state);
      }
    } catch (e) {
      this.status = '错误: ' + (e instanceof Error ? e.message : '');
    }
    this.busy = false;
  }

  async connect(): Promise<void> {
    if (this.busy) {
      return;
    }
    this.busy = true;
    this.status = this.stateLabel('CONNECTING');
    try {
      const result: AddServerResult = await CompositionRoot.get().serverConnectionFlow.addServer({
        name: this.name,
        url: this.url,
        username: this.username,
        password: this.password
      });
      if (result.state === 'CONNECTED' && result.profile !== undefined) {
        this.status = this.stateLabel(result.state) + ' — ' + result.profile.primaryUrl;
        await this.loadSaved();
      } else {
        this.status = this.stateLabel(result.state);
      }
    } catch (e) {
      this.status = '错误: ' + (e instanceof Error ? e.message : '');
    }
    this.busy = false;
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        Text('服务器连接')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.savedSummary)
          .fontSize(13)
          .fontColor('#007AFF')

        if (this.savedServerId !== '' && this.hasSavedCredential) {
          Button(this.busy ? '连接中...' : '使用已保存凭据连接')
            .width('100%')
            .enabled(!this.busy)
            .onClick((): void => {
              this.reconnect();
            })
        }

        TextInput({ placeholder: '服务器名称', text: this.name })
          .onChange((value: string): void => {
            this.name = value;
          })

        TextInput({ placeholder: '服务器地址（域名/IP:端口，可带 /base 路径）', text: this.url })
          .onChange((value: string): void => {
            this.url = value;
          })

        TextInput({ placeholder: '用户名', text: this.username })
          .onChange((value: string): void => {
            this.username = value;
          })

        TextInput({ placeholder: '密码（首次保存或修改密码时填写）', text: this.password })
          .type(InputType.Password)
          .onChange((value: string): void => {
            this.password = value;
          })

        Button(this.busy ? '连接中...' : '连接并保存')
          .width('100%')
          .enabled(!this.busy)
          .onClick((): void => {
            this.connect();
          })

        if (this.status !== '') {
          Text(this.status)
            .fontSize(14)
            .fontColor('#333333')
        }
      }
      .width('100%')
      .padding(20)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
