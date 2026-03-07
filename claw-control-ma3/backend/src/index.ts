import express from 'express';
import cors from 'cors';
import { CONFIG } from './config/settings';
import { IntentParser } from './core/intent-parser';
import { Validator } from './core/validator';
import { Translator } from './core/translator';
import { OSCService } from './services/osc-service';
import { CommandResponse } from './types';

const app = express();
app.use(cors());
app.use(express.json());

const osc = new OSCService();

app.post('/api/command', async (req, res) => {
  const { text } = req.body;
  const timestamp = new Date().toISOString();

  // A. Parsing
  const intent = IntentParser.parse(text);
  
  // B. Validation
  const validation = Validator.validate(intent);
  if (!validation.valid) {
    return res.status(400).json({
      success: false,
      message: validation.error,
      intent,
      timestamp
    });
  }

  try {
    // C. Traduction
    const ma3Command = Translator.toMA3(intent);

    // D. Envoi OSC
    await osc.sendCommand(ma3Command);

    const response: CommandResponse = {
      success: true,
      message: "Commande exécutée avec succès",
      intent,
      ma3Command,
      timestamp
    };
    
    res.json(response);
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: "Erreur lors de l'exécution",
      error: error.message,
      timestamp
    });
  }
});

app.listen(CONFIG.APP.PORT, () => {
  console.log(`ClawControl Backend running on port ${CONFIG.APP.PORT}`);
  console.log(`Mode Simulation: ${CONFIG.APP.SIMULATION_MODE}`);
});