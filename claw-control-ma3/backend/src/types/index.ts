export type IntentType = 
  | 'patch_fixture' 
  | 'select_group' 
  | 'set_dimmer' 
  | 'store_preset' 
  | 'clear_programmer' 
  | 'unknown';

export interface Intent {
  intent: IntentType;
  params: any;
  confidence: number;
}

export interface CommandResponse {
  success: boolean;
  message: string;
  intent?: Intent;
  ma3Command?: string;
  error?: string;
  timestamp: string;
}