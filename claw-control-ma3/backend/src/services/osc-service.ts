import { Client } from 'node-osc';
import { CONFIG } from '../config/settings';

export class OSCService {
  private client: Client;

  constructor() {
    this.client = new Client(CONFIG.OSC.IP, CONFIG.OSC.PORT);
  }

  public sendCommand(command: string): Promise<void> {
    return new Promise((resolve, reject) => {
      if (CONFIG.APP.SIMULATION_MODE) {
        console.log(`[SIMULATION] OSC non envoyé: ${command}`);
        return resolve();
      }

      this.client.send(`${CONFIG.OSC.PREFIX}/cmd`, command, (err) => {
        if (err) reject(err);
        else resolve();
      });
    });
  }
}