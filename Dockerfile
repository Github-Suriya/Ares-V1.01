# Stage 1: Build environment
FROM python:3.10-slim as builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime environment
FROM python:3.10-slim

WORKDIR /app
# Copy only the necessary files from builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Run as non-root user for security
RUN useradd -m myuser && chown -R myuser /app
USER myuser

CMD ["python", "agent.py", "start"]
