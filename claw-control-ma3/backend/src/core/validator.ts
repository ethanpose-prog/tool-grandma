import { Intent } from '../types';
import { CONFIG } from '../config/settings';

export class Validator {
  public static validate(intent: Intent): { valid: boolean; error?: string } {
    if (!CONFIG.SAFE_COMMANDS.includes(intent.intent)) {
      return { valid: false, error: `Intention '${intent.intent}' non autorisée ou inconnue.` };
    }

    const p = intent.params;

    if (intent.intent === 'set_dimmer') {
      if (p.value < 0 || p.value > 100) return { valid: false, error: "Valeur dimmer hors limites (0-100)." };
    }

    if (intent.intent === 'patch_fixture') {
      if (p.universe < 1 || p.universe > 256) return { valid: false, error: "Univers invalide (1-256)." };
      if (p.address < 1 || p.address > 512) return { valid: false, error: "Adresse DMX invalide (1-512)." };
    }

    return { valid: true };
  }
}