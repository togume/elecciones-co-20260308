export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const APPS_SCRIPT_URL = process.env.APPS_SCRIPT_URL;
  if (!APPS_SCRIPT_URL) {
    return res.status(500).json({ error: 'Not configured' });
  }

  try {
    const { contacto, tipo } = req.body;

    if (!contacto || !tipo) {
      return res.status(400).json({ error: 'Missing fields' });
    }

    const response = await fetch(APPS_SCRIPT_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ contacto, tipo }),
    });

    if (!response.ok) {
      throw new Error('Apps Script error');
    }

    return res.status(200).json({ ok: true });
  } catch (err) {
    return res.status(500).json({ error: 'Failed to save' });
  }
}
