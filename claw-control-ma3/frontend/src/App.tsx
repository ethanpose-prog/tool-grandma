import React, { useState, useEffect, useRef } from 'react';
import { Terminal, Send, ShieldCheck, Activity, Database, Settings, Clock, Copy, Play } from 'lucide-react';

const App = () => {
  const [input, setInput] = useState("");
  const [messages, setMessages] = useState<any[]>([]);
  const [logs, setLogs] = useState<any[]>([]);
  const [isSim, setIsSim] = useState(true);
  const chatEndRef = useRef<null | HTMLDivElement>(null);

  const scrollToBottom = () => {
    chatEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const sendCommand = async (overrideText?: string) => {
    const textToSend = overrideText || input;
    if (!textToSend) return;
    
    const userMsg = { role: 'user', text: textToSend, time: new Date().toLocaleTimeString() };
    setMessages(prev => [...prev, userMsg]);
    
    try {
      const response = await fetch('http://localhost:4000/api/command', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text: textToSend })
      });
      
      const data = await response.json();
      setMessages(prev => [...prev, { role: 'bot', ...data }]);
      setLogs(prev => [data, ...prev]);
    } catch (err) {
      setMessages(prev => [...prev, { role: 'bot', success: false, message: "Serveur Backend hors ligne (Port 4000)" }]);
    }
    
    if (!overrideText) setInput("");
  };

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
  };

  return (
    <div className="flex h-screen bg-[#050505] text-zinc-300 font-sans overflow-hidden">
      {/* SIDEBAR */}
      <div className="w-72 border-r border-zinc-800 bg-[#0a0a0a] p-6 flex flex-col gap-8">
        <div className="flex items-center gap-3 text-purple-500">
          <Terminal size={28} />
          <h1 className="font-bold tracking-tighter text-2xl">CLAW_CONTROL</h1>
        </div>

        <div className="space-y-6">
          <div>
            <span className="text-[10px] uppercase font-bold text-zinc-500 tracking-[0.2em] mb-3 block">Système</span>
            <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800">
              <div className="flex justify-between items-center mb-2">
                <span className="text-xs font-medium text-zinc-400">GrandMA3 IP</span>
                <div className="w-2 h-2 rounded-full bg-green-500 shadow-[0_0_8px_rgba(34,197,94,0.6)]" />
              </div>
              <p className="text-sm font-mono text-purple-400">127.0.0.1:8000</p>
            </div>
          </div>

          <button 
            onClick={() => setIsSim(!isSim)}
            className={`w-full p-4 rounded-xl border flex items-center justify-between transition-all duration-300 ${
              isSim 
                ? 'bg-amber-900/10 border-amber-700/50 text-amber-500 hover:bg-amber-900/20' 
                : 'bg-purple-900/10 border-purple-700/50 text-purple-500 hover:bg-purple-900/20'
            }`}
          >
            <div className="flex items-center gap-3">
              <ShieldCheck size={20} />
              <span className="font-bold text-xs uppercase tracking-wider">{isSim ? 'Simulation' : 'Live Mode'}</span>
            </div>
            <div className={`w-10 h-5 rounded-full relative transition-colors ${isSim ? 'bg-amber-900' : 'bg-purple-900'}`}>
              <div className={`absolute top-1 w-3 h-3 rounded-full bg-white transition-all ${isSim ? 'left-1' : 'left-6'}`} />
            </div>
          </button>
        </div>

        <div className="mt-auto">
           <div className="p-4 bg-zinc-900/30 rounded-lg border border-zinc-800/50">
             <p className="text-[10px] text-zinc-500 leading-relaxed">
               Architecture Multi-couches v1.0<br/>
               Parser: Regex Engine<br/>
               OSC: UDP /cmd
             </p>
           </div>
        </div>
      </div>

      {/* CHAT MAIN */}
      <div className="flex-1 flex flex-col relative bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-zinc-900/20 to-[#050505]">
        <div className="flex-1 overflow-y-auto p-8 space-y-8 scrollbar-hide">
          {messages.length === 0 && (
            <div className="h-full flex flex-col items-center justify-center text-zinc-600 space-y-4">
              <Terminal size={48} className="opacity-20" />
              <p className="text-sm font-medium italic">En attente d'une commande...</p>
              <div className="grid grid-cols-2 gap-2 max-w-md">
                {["Clear all", "Mets les wash à 80", "Sélectionne les beams", "Store preset color"].map(t => (
                  <button key={t} onClick={() => sendCommand(t)} className="text-[10px] border border-zinc-800 p-2 rounded hover:bg-zinc-900 transition-colors uppercase tracking-widest">
                    {t}
                  </button>
                ))}
              </div>
            </div>
          )}
          
          {messages.map((m, i) => (
            <div key={i} className={`flex ${m.role === 'user' ? 'justify-end' : 'justify-start'} animate-in fade-in slide-in-from-bottom-2 duration-300`}>
              <div className={`max-w-2xl group ${
                m.role === 'user' ? 'bg-purple-600 text-white rounded-2xl rounded-tr-none p-4 shadow-xl shadow-purple-900/20' : 'w-full'
              }`}>
                {m.role === 'user' ? (
                  <div className="flex items-center gap-3">
                    <p className="text-sm font-medium">{m.text}</p>
                    <span className="text-[9px] opacity-50 font-mono">{m.time}</span>
                  </div>
                ) : (
                  <div className="bg-zinc-900/80 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 space-y-4 shadow-2xl">
                    <div className="flex justify-between items-start">
                      <div className="flex items-center gap-2">
                        <div className={`w-2 h-2 rounded-full ${m.success ? 'bg-emerald-500' : 'bg-red-500'}`} />
                        <p className={`text-sm font-bold ${m.success ? 'text-emerald-400' : 'text-red-400'}`}>
                          {m.success ? 'COMMANDE VALIDE' : 'ERREUR DE VALIDATION'}
                        </p>
                      </div>
                      <span className="text-[10px] text-zinc-600 font-mono">{m.timestamp}</span>
                    </div>
                    
                    <p className="text-zinc-300 text-sm leading-relaxed">{m.message}</p>

                    {m.ma3Command && (
                      <div className="bg-black rounded-xl p-4 border border-emerald-900/30 group/cmd relative">
                        <div className="flex justify-between items-center mb-2">
                          <span className="text-[9px] text-emerald-700 font-bold uppercase tracking-widest">Syntaxe grandMA3</span>
                          <div className="flex gap-2">
                            <button onClick={() => copyToClipboard(m.ma3Command)} className="p-1 hover:text-emerald-400 transition-colors"><Copy size={12} /></button>
                            <button onClick={() => sendCommand(m.text)} className="p-1 hover:text-emerald-400 transition-colors"><Play size={12} /></button>
                          </div>
                        </div>
                        <code className="text-emerald-400 font-mono text-sm block">{m.ma3Command}</code>
                      </div>
                    )}

                    {m.intent && (
                      <div className="flex gap-2 flex-wrap">
                        <span className="px-2 py-1 bg-zinc-800 text-[9px] rounded-md uppercase tracking-wider text-zinc-400 border border-zinc-700">
                          INTENT: {m.intent.intent}
                        </span>
                        <span className="px-2 py-1 bg-zinc-800 text-[9px] rounded-md uppercase tracking-wider text-zinc-400 border border-zinc-700">
                          CONFIDENCE: {Math.round(m.intent.confidence * 100)}%
                        </span>
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          ))}
          <div ref={chatEndRef} />
        </div>

        {/* INPUT AREA */}
        <div className="p-8 bg-gradient-to-t from-[#050505] via-[#050505] to-transparent">
          <div className="relative max-w-4xl mx-auto">
            <div className="absolute -top-6 left-4 flex gap-4">
               <div className="flex items-center gap-1.5">
                  <div className="w-1.5 h-1.5 rounded-full bg-purple-500" />
                  <span className="text-[10px] text-zinc-500 uppercase font-bold tracking-widest">NLP Engine Active</span>
               </div>
            </div>
            <input 
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && sendCommand()}
              placeholder="Ex: Mets les wash à 100..."
              className="w-full bg-zinc-900/50 backdrop-blur-xl border border-zinc-800 rounded-2xl p-6 pr-20 focus:outline-none focus:ring-2 ring-purple-500/50 text-white placeholder-zinc-600 shadow-2xl transition-all"
            />
            <button 
              onClick={() => sendCommand()}
              className="absolute right-3 top-3 bottom-3 px-6 bg-purple-600 text-white rounded-xl hover:bg-purple-500 transition-all hover:scale-105 active:scale-95 shadow-lg shadow-purple-600/20"
            >
              <Send size={20} />
            </button>
          </div>
        </div>
      </div>

      {/* DEBUG PANEL */}
      <div className="w-96 border-l border-zinc-800 bg-[#070707] flex flex-col">
        <div className="p-6 border-b border-zinc-800 flex items-center justify-between">
          <div className="flex items-center gap-2 text-zinc-400">
            <Activity size={18} />
            <span className="text-xs font-bold uppercase tracking-[0.2em]">Flux Technique</span>
          </div>
          <span className="text-[10px] bg-zinc-800 px-2 py-0.5 rounded text-zinc-500 font-mono">JSON</span>
        </div>
        <div className="flex-1 overflow-y-auto p-4 space-y-4 font-mono scrollbar-hide">
          {logs.length === 0 && <p className="text-[10px] text-zinc-700 text-center mt-10 italic">Aucun log disponible</p>}
          {logs.map((log, i) => (
            <div key={i} className="text-[10px] p-4 bg-zinc-900/30 border border-zinc-800 rounded-xl space-y-3">
              <div className="flex justify-between items-center border-b border-zinc-800 pb-2">
                <div className="flex items-center gap-2">
                   <Clock size={10} className="text-zinc-600" />
                   <span className="text-zinc-600">{new Date(log.timestamp).toLocaleTimeString()}</span>
                </div>
                <span className={`font-bold ${log.success ? 'text-emerald-500' : 'text-red-500'}`}>
                  {log.success ? 'VALIDE' : 'REJETÉ'}
                </span>
              </div>
              <div className="space-y-2">
                <p className="text-zinc-500 uppercase text-[8px] font-bold tracking-widest">Intention Détectée</p>
                <pre className="text-purple-400 overflow-x-auto bg-black/40 p-2 rounded leading-tight">
                  {JSON.stringify(log.intent, null, 2)}
                </pre>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default App;